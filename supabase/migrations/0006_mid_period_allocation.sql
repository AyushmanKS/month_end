-- 0006 — Mid-period budget allocation.
-- Buckets created mid-month/mid-week no longer back-allocate budget to days before
-- the creation date. Weeks entirely before creation become 'historical' (no auto
-- allocation, manual total entry). The monthly budget is spread only across active
-- days (creation date -> month end); historical manual totals deduct from the
-- remaining budget and shrink the active allocation via rebalance.

------------------------------------------------------------------------------
-- 1. Schema: classify weeks and remember their effective (active) start
------------------------------------------------------------------------------
alter table weekly_buckets
  add column if not exists kind text not null default 'active';
alter table weekly_buckets
  add column if not exists effective_start_date date;

update weekly_buckets
  set effective_start_date = start_date
  where effective_start_date is null;

------------------------------------------------------------------------------
-- 2. Rebalance active weeks weighted by active-day count
------------------------------------------------------------------------------
create or replace function _rebalance_weeks(p_bucket_id uuid)
returns void language plpgsql as $$
declare
  v_days numeric;
  v_spent numeric;
  v_remaining numeric;
  v_per_day numeric;
begin
  select coalesce(sum(end_date - effective_start_date + 1), 0),
         coalesce(sum(spent_amount), 0)
    into v_days, v_spent
    from weekly_buckets
    where bucket_id = p_bucket_id and kind = 'active';
  if v_days <= 0 then return; end if;
  select remaining_main_bucket into v_remaining from buckets where id = p_bucket_id;
  v_per_day := (v_remaining + v_spent) / v_days;
  if v_per_day < 0 then v_per_day := 0; end if;
  update weekly_buckets
    set allocated_amount = round(v_per_day * (end_date - effective_start_date + 1), 2),
        remaining_amount = round(v_per_day * (end_date - effective_start_date + 1), 2)
                           - spent_amount
    where bucket_id = p_bucket_id and kind = 'active';
end;
$$;

------------------------------------------------------------------------------
-- 3. Create bucket with creation-date-aware weeks
------------------------------------------------------------------------------
create or replace function create_bucket(p_name text, p_budget numeric)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
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

  insert into buckets (name, owner_id, join_code, monthly_budget,
                       month_start_date, remaining_main_bucket)
  values (p_name, v_uid, gen_join_code(), p_budget, v_month_start, p_budget)
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
-- 4. Manual total for a historical week (deducts from the remaining budget)
------------------------------------------------------------------------------
create or replace function set_week_manual_total(p_week_id uuid, p_amount numeric)
returns weekly_buckets language plpgsql security definer set search_path = public as $$
declare
  v_week weekly_buckets;
  v_amount numeric := coalesce(p_amount, 0);
  v_delta numeric;
begin
  select * into v_week from weekly_buckets where id = p_week_id;
  if v_week.id is null then raise exception 'week not found'; end if;
  if not is_bucket_member(v_week.bucket_id) then raise exception 'not a member'; end if;
  if v_week.kind <> 'historical' then raise exception 'not a historical week'; end if;
  if v_amount < 0 then raise exception 'amount must be positive'; end if;

  v_delta := v_amount - v_week.spent_amount;

  update weekly_buckets
    set spent_amount = v_amount,
        remaining_amount = -v_amount
    where id = p_week_id
    returning * into v_week;

  update buckets
    set remaining_main_bucket = remaining_main_bucket - v_delta, updated_at = now()
    where id = v_week.bucket_id;

  perform _rebalance_weeks(v_week.bucket_id);
  return v_week;
end;
$$;
