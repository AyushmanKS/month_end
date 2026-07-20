-- Row Level Security policies.
-- Supabase locks every table by default; these policies grant the minimum access
-- described in the PRD permission model.

alter table users            enable row level security;
alter table buckets          enable row level security;
alter table bucket_members   enable row level security;
alter table weekly_buckets   enable row level security;
alter table categories       enable row level security;
alter table expenses         enable row level security;
alter table big_expenses     enable row level security;
alter table notifications    enable row level security;
alter table suggestions      enable row level security;

-- Helper: is the current user a member of the bucket?
create or replace function is_bucket_member(target_bucket uuid)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from bucket_members
    where bucket_id = target_bucket and user_id = auth.uid()
  );
$$;

-- Helper: is the current user the owner of the bucket?
create or replace function is_bucket_owner(target_bucket uuid)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from buckets
    where id = target_bucket and owner_id = auth.uid()
  );
$$;

-- users -------------------------------------------------------------------
create policy users_select_self_or_shared on users
  for select using (true);
create policy users_insert_self on users
  for insert with check (id = auth.uid());
create policy users_update_self on users
  for update using (id = auth.uid());

-- buckets -----------------------------------------------------------------
create policy buckets_select_member on buckets
  for select using (is_bucket_member(id) or owner_id = auth.uid());
create policy buckets_insert_owner on buckets
  for insert with check (owner_id = auth.uid());
create policy buckets_update_owner on buckets
  for update using (owner_id = auth.uid());
create policy buckets_delete_owner on buckets
  for delete using (owner_id = auth.uid());

-- bucket_members ----------------------------------------------------------
create policy members_select on bucket_members
  for select using (is_bucket_member(bucket_id) or is_bucket_owner(bucket_id));
create policy members_insert_self_or_owner on bucket_members
  for insert with check (user_id = auth.uid() or is_bucket_owner(bucket_id));
create policy members_delete_self_or_owner on bucket_members
  for delete using (user_id = auth.uid() or is_bucket_owner(bucket_id));

-- weekly_buckets ----------------------------------------------------------
create policy weekly_select_member on weekly_buckets
  for select using (is_bucket_member(bucket_id));
create policy weekly_write_member on weekly_buckets
  for insert with check (is_bucket_member(bucket_id));
create policy weekly_update_member on weekly_buckets
  for update using (is_bucket_member(bucket_id));

-- categories (global read, writes reserved for service role) ---------------
create policy categories_select_all on categories
  for select using (true);

-- expenses ----------------------------------------------------------------
create policy expenses_select_member on expenses
  for select using (
    bucket_id in (select bucket_id from bucket_members where user_id = auth.uid())
  );
create policy expenses_insert_member on expenses
  for insert with check (
    added_by_uid = auth.uid() and is_bucket_member(bucket_id)
  );
create policy expenses_update_owner_or_author on expenses
  for update using (
    added_by_uid = auth.uid()
    or bucket_id in (select id from buckets where owner_id = auth.uid())
  );
create policy expenses_delete_owner_or_author on expenses
  for delete using (
    added_by_uid = auth.uid()
    or bucket_id in (select id from buckets where owner_id = auth.uid())
  );

-- big_expenses ------------------------------------------------------------
create policy big_expenses_select_member on big_expenses
  for select using (is_bucket_member(bucket_id));
create policy big_expenses_insert_member on big_expenses
  for insert with check (added_by_uid = auth.uid() and is_bucket_member(bucket_id));
create policy big_expenses_delete_owner_or_author on big_expenses
  for delete using (added_by_uid = auth.uid() or is_bucket_owner(bucket_id));

-- notifications -----------------------------------------------------------
create policy notifications_select_member on notifications
  for select using (is_bucket_member(bucket_id));
create policy notifications_insert_member on notifications
  for insert with check (is_bucket_member(bucket_id));
create policy notifications_update_member on notifications
  for update using (is_bucket_member(bucket_id));

-- suggestions -------------------------------------------------------------
create policy suggestions_select_member on suggestions
  for select using (is_bucket_member(bucket_id));
