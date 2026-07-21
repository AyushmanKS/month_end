-- 0004 — Security hardening + atomic money-math RPCs.
-- Fixes: world-readable users table, join-without-code, missing WITH CHECK,
-- non-atomic balance updates, partial writes, wrong-week assignment,
-- threshold-notification spam, non-atomic read state.
--
-- Strategy: all balance/budget mutations move into SECURITY DEFINER functions
-- that run atomically in a single statement/transaction. Client write policies
-- on the financial tables are then removed so clients can only mutate through
-- these audited functions.

------------------------------------------------------------------------------
-- 1. RLS: stop leaking every user's PII
------------------------------------------------------------------------------
drop policy if exists users_select_self_or_shared on users;
create policy users_select_self_or_shared on users
  for select using (
    id = auth.uid()
    or exists (
      select 1
      from bucket_members m_self
      join bucket_members m_other
        on m_self.bucket_id = m_other.bucket_id
      where m_self.user_id = auth.uid()
        and m_other.user_id = users.id
    )
  );

-- Re-validate the post-update row so a user can't rewrite their own id.
drop policy if exists users_update_self on users;
create policy users_update_self on users
  for update using (id = auth.uid()) with check (id = auth.uid());

------------------------------------------------------------------------------
-- 2. RLS: lock down owner-only and financial tables
------------------------------------------------------------------------------
-- buckets: owner can't reassign owner_id to someone else
drop policy if exists buckets_update_owner on buckets;
create policy buckets_update_owner on buckets
  for update using (owner_id = auth.uid()) with check (owner_id = auth.uid());

-- bucket_members: self-join now goes through join_bucket_with_code(); only the
-- owner may add members directly.
drop policy if exists members_insert_self_or_owner on bucket_members;
create policy members_insert_owner on bucket_members
  for insert with check (is_bucket_owner(bucket_id));

-- weekly_buckets: only the RPCs (security definer) may write.
drop policy if exists weekly_write_member on weekly_buckets;
drop policy if exists weekly_update_member on weekly_buckets;

-- notifications: only the RPCs (security definer) may insert/update.
drop policy if exists notifications_insert_member on notifications;
drop policy if exists notifications_update_member on notifications;

-- expenses / big_expenses: writes now flow through the RPCs; keep read policies.
drop policy if exists expenses_insert_member on expenses;
drop policy if exists expenses_update_owner_or_author on expenses;
drop policy if exists expenses_delete_owner_or_author on expenses;
drop policy if exists big_expenses_insert_member on big_expenses;
drop policy if exists big_expenses_delete_owner_or_author on big_expenses;

------------------------------------------------------------------------------
-- 3. Helpers
------------------------------------------------------------------------------
create or replace function gen_join_code()
returns text language plpgsql as $$
declare
  alphabet text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  code text;
  i int;
begin
  loop
    code := '';
    for i in 1..6 loop
      code := code || substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1);
    end loop;
    exit when not exists (select 1 from buckets where join_code = code);
  end loop;
  return code;
end;
$$;

-- Rebalance active weeks for a bucket (mirrors CalculateWeeklyAllocation).
create or replace function _rebalance_weeks(p_bucket_id uuid)
returns void language plpgsql as $$
declare
  v_active int;
  v_spent numeric;
  v_remaining numeric;
  v_per numeric;
begin
  select count(*), coalesce(sum(spent_amount), 0)
    into v_active, v_spent
    from weekly_buckets
    where bucket_id = p_bucket_id and status = 'active';
  if v_active = 0 then return; end if;
  select remaining_main_bucket into v_remaining from buckets where id = p_bucket_id;
  v_per := (v_remaining + v_spent) / v_active;
  if v_per < 0 then v_per := 0; end if;
  update weekly_buckets
    set allocated_amount = v_per,
        remaining_amount = v_per - spent_amount
    where bucket_id = p_bucket_id and status = 'active';
end;
$$;

create or replace function _notify(p_bucket_id uuid, p_type text, p_message text)
returns void language sql security definer set search_path = public as $$
  insert into notifications (bucket_id, type, actor_uid, message)
  values (p_bucket_id, p_type, auth.uid(), p_message);
$$;

------------------------------------------------------------------------------
-- 4. Bucket lifecycle RPCs
------------------------------------------------------------------------------
create or replace function create_bucket(p_name text, p_budget numeric)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
  v_month_start date := date_trunc('month', now())::date;
  v_month_end date := (date_trunc('month', now()) + interval '1 month - 1 day')::date;
  v_cursor date := date_trunc('month', now())::date;
  v_win_end date;
  v_count int;
  v_idx int := 0;
  v_base numeric;
  v_alloc numeric;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;

  insert into buckets (name, owner_id, join_code, monthly_budget,
                       month_start_date, remaining_main_bucket)
  values (p_name, v_uid, gen_join_code(), p_budget, v_month_start, p_budget)
  returning * into v_bucket;

  insert into bucket_members (bucket_id, user_id) values (v_bucket.id, v_uid);

  v_count := ceil((v_month_end - v_month_start + 1)::numeric / 7);
  v_base := round(p_budget / v_count, 2);
  while v_cursor <= v_month_end loop
    v_win_end := least(v_cursor + 6, v_month_end);
    -- last window absorbs the rounding remainder
    if v_idx = v_count - 1 then
      v_alloc := p_budget - v_base * (v_count - 1);
    else
      v_alloc := v_base;
    end if;
    insert into weekly_buckets (bucket_id, week_index, start_date, end_date,
                               allocated_amount, spent_amount, remaining_amount, status)
    values (v_bucket.id, v_idx, v_cursor, v_win_end, v_alloc, 0, v_alloc, 'active');
    v_cursor := v_win_end + 1;
    v_idx := v_idx + 1;
  end loop;

  return v_bucket;
end;
$$;

create or replace function join_bucket_with_code(p_code text)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  select * into v_bucket from buckets where join_code = upper(p_code);
  if v_bucket.id is null then
    raise exception 'No bucket found for that code.' using errcode = 'no_data_found';
  end if;
  insert into bucket_members (bucket_id, user_id)
  values (v_bucket.id, v_uid)
  on conflict do nothing;
  return v_bucket;
end;
$$;

create or replace function update_monthly_budget(p_bucket_id uuid, p_budget numeric)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_bucket buckets;
  v_spent numeric;
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  select * into v_bucket from buckets where id = p_bucket_id;
  v_spent := v_bucket.monthly_budget - v_bucket.remaining_main_bucket;
  update buckets
    set monthly_budget = p_budget,
        remaining_main_bucket = p_budget - v_spent,
        updated_at = now()
    where id = p_bucket_id
    returning * into v_bucket;
  perform _rebalance_weeks(p_bucket_id);
  return v_bucket;
end;
$$;

------------------------------------------------------------------------------
-- 5. Expense RPCs (atomic: row + deltas + notifications in one transaction)
------------------------------------------------------------------------------
create or replace function add_expense(
  p_bucket_id uuid, p_amount numeric, p_category_id uuid,
  p_note text, p_receipt text)
returns expenses language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_week weekly_buckets;
  v_expense expenses;
  v_old_progress numeric := 0;
  v_new_progress numeric := 0;
begin
  if not is_bucket_member(p_bucket_id) then raise exception 'not a member'; end if;

  select * into v_week from weekly_buckets
    where bucket_id = p_bucket_id and status = 'active'
      and current_date between start_date and end_date
    order by week_index limit 1;

  insert into expenses (bucket_id, week_id, added_by_uid, amount, category_id, note, receipt_image_url)
  values (p_bucket_id, v_week.id, v_uid, p_amount, p_category_id, p_note, p_receipt)
  returning * into v_expense;

  if v_week.id is not null then
    if v_week.allocated_amount > 0 then
      v_old_progress := least(v_week.spent_amount / v_week.allocated_amount, 1);
    end if;
    update weekly_buckets
      set spent_amount = spent_amount + p_amount,
          remaining_amount = allocated_amount - (spent_amount + p_amount)
      where id = v_week.id
      returning * into v_week;
    if v_week.allocated_amount > 0 then
      v_new_progress := least(v_week.spent_amount / v_week.allocated_amount, 1);
    end if;
  end if;

  update buckets
    set remaining_main_bucket = remaining_main_bucket - p_amount, updated_at = now()
    where id = p_bucket_id;

  perform _notify(p_bucket_id, 'expense_added',
    'A new expense of ' || round(p_amount)::text || ' was added');
  -- only alert on the transition across 80%
  if v_old_progress < 0.8 and v_new_progress >= 0.8 then
    perform _notify(p_bucket_id, 'budget_threshold',
      'Week ' || (v_week.week_index + 1)::text || ' is at '
        || round(v_new_progress * 100)::text || '% of its budget');
  end if;

  return v_expense;
end;
$$;

create or replace function edit_expense(
  p_expense_id uuid, p_amount numeric, p_category_id uuid,
  p_note text, p_receipt text)
returns expenses language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_old expenses;
  v_new expenses;
  v_delta numeric;
begin
  select * into v_old from expenses where id = p_expense_id;
  if v_old.id is null then raise exception 'expense not found'; end if;
  if not is_bucket_member(v_old.bucket_id) then raise exception 'not a member'; end if;

  update expenses set
    amount = coalesce(p_amount, amount),
    category_id = coalesce(p_category_id, category_id),
    note = coalesce(p_note, note),
    receipt_image_url = coalesce(p_receipt, receipt_image_url),
    edited_by_uid = v_uid,
    updated_at = now()
    where id = p_expense_id
    returning * into v_new;

  v_delta := v_new.amount - v_old.amount;
  if v_delta <> 0 then
    if v_old.week_id is not null then
      update weekly_buckets
        set spent_amount = spent_amount + v_delta,
            remaining_amount = allocated_amount - (spent_amount + v_delta)
        where id = v_old.week_id;
    end if;
    update buckets
      set remaining_main_bucket = remaining_main_bucket - v_delta, updated_at = now()
      where id = v_old.bucket_id;
  end if;

  perform _notify(v_old.bucket_id, 'expense_edited', 'An expense was edited');
  return v_new;
end;
$$;

create or replace function delete_expense(p_expense_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_exp expenses;
begin
  select * into v_exp from expenses where id = p_expense_id;
  if v_exp.id is null then return; end if;
  if not is_bucket_member(v_exp.bucket_id) then raise exception 'not a member'; end if;

  delete from expenses where id = p_expense_id;

  if v_exp.week_id is not null then
    update weekly_buckets
      set spent_amount = spent_amount - v_exp.amount,
          remaining_amount = allocated_amount - (spent_amount - v_exp.amount)
      where id = v_exp.week_id;
  end if;
  update buckets
    set remaining_main_bucket = remaining_main_bucket + v_exp.amount, updated_at = now()
    where id = v_exp.bucket_id;

  perform _notify(v_exp.bucket_id, 'expense_deleted', 'An expense was deleted');
end;
$$;

create or replace function add_big_expense(p_bucket_id uuid, p_title text, p_amount numeric)
returns big_expenses language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_big big_expenses;
begin
  if not is_bucket_member(p_bucket_id) then raise exception 'not a member'; end if;

  insert into big_expenses (bucket_id, added_by_uid, title, amount)
  values (p_bucket_id, v_uid, p_title, p_amount)
  returning * into v_big;

  update buckets
    set remaining_main_bucket = remaining_main_bucket - p_amount, updated_at = now()
    where id = p_bucket_id;
  perform _rebalance_weeks(p_bucket_id);

  perform _notify(p_bucket_id, 'big_expense_added',
    p_title || ' (' || round(p_amount)::text || ') added as a big expense');
  return v_big;
end;
$$;

------------------------------------------------------------------------------
-- 6. Notification read state (atomic array append)
------------------------------------------------------------------------------
create or replace function mark_notifications_read(p_bucket_id uuid)
returns void language sql security definer set search_path = public as $$
  update notifications
    set read_by = array_append(read_by, auth.uid())
    where bucket_id = p_bucket_id
      and is_bucket_member(p_bucket_id)
      and not (auth.uid() = any(read_by));
$$;
