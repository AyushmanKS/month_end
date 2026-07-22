-- 0009 — Offline-sync compatibility: idempotent RPCs + client-generated UUIDs.
-- Every "insert" RPC now accepts an optional client id (p_id) and short-circuits if a row
-- with that id already exists, so a replayed command never duplicates a row or re-applies
-- money math. set_bucket_currency becomes idempotent via an expected-currency guard.
-- All new params default to null, so existing (online) callers are unaffected.

------------------------------------------------------------------------------
-- create_bucket — client id + idempotent
------------------------------------------------------------------------------
create or replace function create_bucket(
  p_name text, p_budget numeric, p_currency text default 'INR',
  p_id uuid default null)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
  v_existing buckets;
  v_month_start date := date_trunc('month', now())::date;
  v_month_end date := (date_trunc('month', now()) + interval '1 month - 1 day')::date;
  v_today date := current_date;
  v_cursor date := date_trunc('month', now())::date;
  v_win_end date;
  v_eff_start date;
  v_active_days int;
  v_total_active_days int;
  v_per_day numeric;
  v_idx int := 0;
  v_kind text;
  v_alloc numeric;
  v_alloc_sum numeric := 0;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;

  if p_id is not null then
    select * into v_existing from buckets where id = p_id;
    if v_existing.id is not null then return v_existing; end if;
  end if;

  insert into buckets (id, name, owner_id, join_code, monthly_budget,
                       month_start_date, remaining_main_bucket, currency)
  values (coalesce(p_id, gen_random_uuid()), p_name, v_uid, gen_join_code(), p_budget,
          v_month_start, p_budget, coalesce(p_currency, 'INR'))
  returning * into v_bucket;

  insert into bucket_members (bucket_id, user_id) values (v_bucket.id, v_uid);

  v_total_active_days := greatest(v_month_end - greatest(v_today, v_month_start) + 1, 1);
  v_per_day := p_budget / v_total_active_days;

  while v_cursor <= v_month_end loop
    v_win_end := least(v_cursor + 6, v_month_end);
    if v_win_end < v_today then
      v_kind := 'historical';
      v_eff_start := v_cursor;
      v_alloc := 0;
    else
      v_kind := 'active';
      v_eff_start := greatest(v_cursor, v_today);
      if v_win_end = v_month_end then
        v_alloc := p_budget - v_alloc_sum;
      else
        v_alloc := round(v_per_day * (v_win_end - v_eff_start + 1), 2);
      end if;
      v_alloc_sum := v_alloc_sum + v_alloc;
    end if;

    v_active_days := v_win_end - v_eff_start + 1;

    insert into weekly_buckets (bucket_id, week_index, start_date, end_date,
                               effective_start_date, kind, allocated_amount,
                               spent_amount, remaining_amount, status)
    values (v_bucket.id, v_idx, v_cursor, v_win_end, v_eff_start, v_kind,
            v_alloc, 0, v_alloc, 'active');

    v_cursor := v_win_end + 1;
    v_idx := v_idx + 1;
  end loop;

  return v_bucket;
end;
$$;

------------------------------------------------------------------------------
-- add_expense — client id + idempotent (deltas apply once)
------------------------------------------------------------------------------
create or replace function add_expense(
  p_bucket_id uuid, p_amount numeric, p_category_id uuid,
  p_note text, p_receipt text,
  p_occurred_at timestamptz default null, p_local_date date default null,
  p_id uuid default null)
returns expenses language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_week weekly_buckets;
  v_expense expenses;
  v_existing expenses;
  v_match_date date := coalesce(p_local_date, current_date);
  v_created timestamptz := coalesce(p_occurred_at, now());
  v_old_progress numeric := 0;
  v_new_progress numeric := 0;
begin
  if not is_bucket_member(p_bucket_id) then raise exception 'not a member'; end if;

  if p_id is not null then
    select * into v_existing from expenses where id = p_id;
    if v_existing.id is not null then return v_existing; end if;
  end if;

  select * into v_week from weekly_buckets
    where bucket_id = p_bucket_id and status = 'active'
      and v_match_date between start_date and end_date
    order by week_index limit 1;

  insert into expenses (id, bucket_id, week_id, added_by_uid, amount, category_id,
                        note, receipt_image_url, created_at)
  values (coalesce(p_id, gen_random_uuid()), p_bucket_id, v_week.id, v_uid, p_amount,
          p_category_id, p_note, p_receipt, v_created)
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
  if v_old_progress < 0.8 and v_new_progress >= 0.8 then
    perform _notify(p_bucket_id, 'budget_threshold',
      'Week ' || (v_week.week_index + 1)::text || ' is at '
        || round(v_new_progress * 100)::text || '% of its budget');
  end if;

  return v_expense;
end;
$$;

------------------------------------------------------------------------------
-- add_big_expense — client id + idempotent
------------------------------------------------------------------------------
create or replace function add_big_expense(
  p_bucket_id uuid, p_title text, p_amount numeric, p_id uuid default null)
returns big_expenses language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_big big_expenses;
  v_existing big_expenses;
begin
  if not is_bucket_member(p_bucket_id) then raise exception 'not a member'; end if;

  if p_id is not null then
    select * into v_existing from big_expenses where id = p_id;
    if v_existing.id is not null then return v_existing; end if;
  end if;

  insert into big_expenses (id, bucket_id, added_by_uid, title, amount)
  values (coalesce(p_id, gen_random_uuid()), p_bucket_id, v_uid, p_title, p_amount)
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
-- add_custom_category — client id + idempotent
------------------------------------------------------------------------------
create or replace function add_custom_category(
  p_name text, p_icon text, p_id uuid default null)
returns categories language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_row categories;
  v_existing categories;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  if coalesce(trim(p_name), '') = '' then raise exception 'name required'; end if;

  if p_id is not null then
    select * into v_existing from categories where id = p_id;
    if v_existing.id is not null then return v_existing; end if;
  end if;

  insert into categories (id, name, icon, is_preset, owner_uid)
  values (coalesce(p_id, gen_random_uuid()), trim(p_name),
          coalesce(p_icon, 'other'), false, v_uid)
  returning * into v_row;
  return v_row;
end;
$$;

------------------------------------------------------------------------------
-- set_bucket_currency — idempotent conversion via expected-currency guard
------------------------------------------------------------------------------
create or replace function set_bucket_currency(
  p_bucket_id uuid, p_currency text, p_rate numeric default 1,
  p_expected_current text default null)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_bucket buckets;
  v_rate numeric := coalesce(p_rate, 1);
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  if v_rate <= 0 then raise exception 'rate must be positive'; end if;

  select * into v_bucket from buckets where id = p_bucket_id;

  if v_rate <> 1
     and (p_expected_current is null or v_bucket.currency = p_expected_current)
     and v_bucket.currency <> p_currency then
    update buckets
      set monthly_budget = round(monthly_budget * v_rate, 2),
          remaining_main_bucket = round(remaining_main_bucket * v_rate, 2)
      where id = p_bucket_id;
    update weekly_buckets
      set allocated_amount = round(allocated_amount * v_rate, 2),
          spent_amount = round(spent_amount * v_rate, 2),
          remaining_amount = round(remaining_amount * v_rate, 2)
      where bucket_id = p_bucket_id;
    update expenses set amount = round(amount * v_rate, 2)
      where bucket_id = p_bucket_id;
    update big_expenses set amount = round(amount * v_rate, 2)
      where bucket_id = p_bucket_id;
  end if;

  update buckets
    set currency = p_currency, updated_at = now()
    where id = p_bucket_id
    returning * into v_bucket;
  return v_bucket;
end;
$$;
