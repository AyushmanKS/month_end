------------------------------------------------------------------------------
-- 0012 Notifications, Activity & Bucket Lifecycle (Phase 0, backwards compatible)
------------------------------------------------------------------------------

-- 1. Bucket lifecycle columns + member role -----------------------------------
alter table buckets add column if not exists status text not null default 'active';
alter table buckets add column if not exists deleted_at timestamptz;
alter table buckets add column if not exists deleted_by uuid references users(id) on delete set null;
alter table buckets add column if not exists delete_after timestamptz;

alter table bucket_members add column if not exists role text not null default 'member';

update bucket_members bm
  set role = 'owner'
  from buckets b
  where b.id = bm.bucket_id and b.owner_id = bm.user_id and bm.role <> 'owner';

-- 2. Hide non-active buckets from normal reads (old and new clients) -----------
drop policy if exists buckets_select_member on buckets;
create policy buckets_select_member on buckets
  for select using (
    (is_bucket_member(id) or owner_id = auth.uid())
    and status in ('active', 'archived')
  );

-- 3. Append-only bucket activity (audit) --------------------------------------
create table if not exists bucket_activity (
  id             uuid primary key default gen_random_uuid(),
  bucket_id      uuid not null references buckets(id) on delete cascade,
  actor_uid      uuid references users(id) on delete set null,
  type           text not null,
  category       text not null default 'bucket',
  summary        text not null default '',
  metadata       jsonb not null default '{}',
  correlation_id uuid not null default gen_random_uuid(),
  created_at     timestamptz not null default now()
);
create index if not exists idx_activity_bucket_keyset
  on bucket_activity (bucket_id, created_at desc, id desc);
create index if not exists idx_activity_correlation
  on bucket_activity (correlation_id);

alter table bucket_activity enable row level security;
drop policy if exists activity_select_member on bucket_activity;
create policy activity_select_member on bucket_activity
  for select using (is_bucket_member(bucket_id));

create or replace function _forbid_activity_mutation()
returns trigger language plpgsql as $$
begin
  raise exception 'bucket_activity is append-only';
end;
$$;
drop trigger if exists trg_activity_immutable on bucket_activity;
create trigger trg_activity_immutable
  before update on bucket_activity
  for each row execute function _forbid_activity_mutation();

-- 4. Per-user notifications inbox ---------------------------------------------
create table if not exists user_notifications (
  id             uuid primary key default gen_random_uuid(),
  recipient_uid  uuid not null references users(id) on delete cascade,
  event_id       uuid not null,
  type           text not null,
  category       text not null default 'bucket',
  bucket_id      uuid references buckets(id) on delete set null,
  bucket_name    text not null default '',
  actor_uid      uuid references users(id) on delete set null,
  title          text not null default '',
  body           text not null default '',
  metadata       jsonb not null default '{}',
  correlation_id uuid,
  created_at     timestamptz not null default now(),
  read_at        timestamptz,
  archived_at    timestamptz,
  unique (recipient_uid, event_id)
);
create index if not exists idx_notif_recipient_keyset
  on user_notifications (recipient_uid, created_at desc, id desc);
create index if not exists idx_notif_unread
  on user_notifications (recipient_uid)
  where read_at is null and archived_at is null;
create index if not exists idx_notif_archived
  on user_notifications (recipient_uid, archived_at);

alter table user_notifications enable row level security;
drop policy if exists notif_select_own on user_notifications;
create policy notif_select_own on user_notifications
  for select using (recipient_uid = auth.uid());
drop policy if exists notif_update_own on user_notifications;
create policy notif_update_own on user_notifications
  for update using (recipient_uid = auth.uid());

-- 5. Notification preferences (future-ready, defaults only) --------------------
create table if not exists user_notification_preferences (
  user_uid   uuid primary key references users(id) on delete cascade,
  prefs      jsonb not null default '{}',
  updated_at timestamptz not null default now()
);
alter table user_notification_preferences enable row level security;
drop policy if exists prefs_select_own on user_notification_preferences;
create policy prefs_select_own on user_notification_preferences
  for select using (user_uid = auth.uid());
drop policy if exists prefs_upsert_own on user_notification_preferences;
create policy prefs_upsert_own on user_notification_preferences
  for all using (user_uid = auth.uid()) with check (user_uid = auth.uid());

-- 6. Realtime publication ------------------------------------------------------
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public'
      and tablename = 'user_notifications'
  ) then
    alter publication supabase_realtime add table user_notifications;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public'
      and tablename = 'bucket_activity'
  ) then
    alter publication supabase_realtime add table bucket_activity;
  end if;
end $$;

-- 7. Category + preference helpers ---------------------------------------------
create or replace function _notif_category(p_type text)
returns text language sql immutable as $$
  select case
    when p_type in ('expense_added','expense_edited','expense_deleted','big_expense_added') then 'expense'
    when p_type in ('member_joined','member_left','member_removed','removed_from_bucket',
                    'join_requested','join_accepted','join_rejected') then 'membership'
    when p_type in ('ownership_transferred','ownership_transferred_to_you','ownership_transferred_away') then 'ownership'
    when p_type in ('bucket_created','bucket_archived','bucket_restored','bucket_deleted',
                    'budget_threshold','budget_changed','currency_changed','week_total_edited') then 'bucket'
    when p_type in ('app_update','system_announcement') then 'system'
    else 'bucket'
  end;
$$;

create or replace function _notif_allowed(p_recipient uuid, p_category text, p_type text)
returns boolean language sql stable security definer set search_path = public as $$
  select case
    when p_category in ('security','ownership')
      or p_type in ('bucket_deleted','removed_from_bucket') then true
    else coalesce(
      (select (prefs -> p_category ->> 'in_app')::boolean
         from user_notification_preferences where user_uid = p_recipient),
      true)
  end;
$$;

-- 8. Single pipeline: emit_activity -> fan-out trigger -------------------------
create or replace function fan_out_notifications()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  v_name text;
  v_target uuid;
  v_old uuid;
  v_new uuid;
  v_cat text := new.category;
begin
  select name into v_name from buckets where id = new.bucket_id;
  v_name := coalesce(v_name, '');

  if new.type = 'member_removed' then
    v_target := nullif(new.metadata ->> 'target_uid', '')::uuid;
    if v_target is not null then
      insert into user_notifications (recipient_uid, event_id, type, category,
        bucket_id, bucket_name, actor_uid, title, body, metadata, correlation_id)
      values (v_target, new.id, 'removed_from_bucket', 'membership',
        new.bucket_id, v_name, new.actor_uid, 'Removed from bucket',
        'You were removed from ' || v_name, new.metadata, new.correlation_id)
      on conflict (recipient_uid, event_id) do nothing;
    end if;
    insert into user_notifications (recipient_uid, event_id, type, category,
      bucket_id, bucket_name, actor_uid, title, body, metadata, correlation_id)
    select m.user_id, new.id, 'member_removed', 'membership', new.bucket_id,
      v_name, new.actor_uid, 'Member removed', new.summary, new.metadata, new.correlation_id
    from bucket_members m
    where m.bucket_id = new.bucket_id
      and m.user_id <> coalesce(new.actor_uid, '00000000-0000-0000-0000-000000000000')
      and _notif_allowed(m.user_id, 'membership', 'member_removed')
    on conflict (recipient_uid, event_id) do nothing;
    return null;
  end if;

  if new.type = 'ownership_transferred' then
    v_old := nullif(new.metadata ->> 'old_owner', '')::uuid;
    v_new := nullif(new.metadata ->> 'new_owner', '')::uuid;
    if v_new is not null then
      insert into user_notifications (recipient_uid, event_id, type, category,
        bucket_id, bucket_name, actor_uid, title, body, metadata, correlation_id)
      values (v_new, new.id, 'ownership_transferred_to_you', 'ownership',
        new.bucket_id, v_name, new.actor_uid, 'You are now the owner',
        'You now own ' || v_name, new.metadata, new.correlation_id)
      on conflict (recipient_uid, event_id) do nothing;
    end if;
    if v_old is not null and v_old <> coalesce(v_new, v_old) then
      insert into user_notifications (recipient_uid, event_id, type, category,
        bucket_id, bucket_name, actor_uid, title, body, metadata, correlation_id)
      values (v_old, new.id, 'ownership_transferred_away', 'ownership',
        new.bucket_id, v_name, new.actor_uid, 'Ownership transferred',
        'You transferred ' || v_name, new.metadata, new.correlation_id)
      on conflict (recipient_uid, event_id) do nothing;
    end if;
    insert into user_notifications (recipient_uid, event_id, type, category,
      bucket_id, bucket_name, actor_uid, title, body, metadata, correlation_id)
    select m.user_id, new.id, 'ownership_transferred', 'ownership', new.bucket_id,
      v_name, new.actor_uid, 'Ownership changed', new.summary, new.metadata, new.correlation_id
    from bucket_members m
    where m.bucket_id = new.bucket_id
      and m.user_id not in (coalesce(v_old, '00000000-0000-0000-0000-000000000000'),
                            coalesce(v_new, '00000000-0000-0000-0000-000000000000'))
    on conflict (recipient_uid, event_id) do nothing;
    return null;
  end if;

  insert into user_notifications (recipient_uid, event_id, type, category,
    bucket_id, bucket_name, actor_uid, title, body, metadata, correlation_id)
  select m.user_id, new.id, new.type, v_cat, new.bucket_id, v_name,
    new.actor_uid, initcap(replace(new.type, '_', ' ')), new.summary,
    new.metadata, new.correlation_id
  from bucket_members m
  where m.bucket_id = new.bucket_id
    and m.user_id <> coalesce(new.actor_uid, '00000000-0000-0000-0000-000000000000')
    and _notif_allowed(m.user_id, v_cat, new.type)
  on conflict (recipient_uid, event_id) do nothing;
  return null;
end;
$$;

drop trigger if exists trg_activity_fanout on bucket_activity;
create trigger trg_activity_fanout
  after insert on bucket_activity
  for each row execute function fan_out_notifications();

create or replace function emit_activity(
  p_bucket_id uuid, p_type text, p_actor uuid, p_summary text,
  p_metadata jsonb default '{}', p_correlation_id uuid default null)
returns uuid language plpgsql security definer set search_path = public as $$
declare v_id uuid;
begin
  insert into bucket_activity (bucket_id, actor_uid, type, category, summary,
    metadata, correlation_id)
  values (p_bucket_id, p_actor, p_type, _notif_category(p_type), p_summary,
    coalesce(p_metadata, '{}'), coalesce(p_correlation_id, gen_random_uuid()))
  returning id into v_id;
  return v_id;
end;
$$;

-- Bridge legacy _notify into the new pipeline so existing money RPCs auto-emit.
create or replace function _notify(p_bucket_id uuid, p_type text, p_message text)
returns void language plpgsql security definer set search_path = public as $$
begin
  insert into notifications (bucket_id, type, actor_uid, message)
  values (p_bucket_id, p_type, auth.uid(), p_message);
  perform emit_activity(p_bucket_id, p_type, auth.uid(), p_message);
end;
$$;

create or replace function emit_system_notification(
  p_recipient uuid, p_type text, p_title text, p_body text,
  p_metadata jsonb default '{}')
returns void language plpgsql security definer set search_path = public as $$
begin
  insert into user_notifications (recipient_uid, event_id, type, category,
    title, body, metadata, correlation_id)
  values (p_recipient, gen_random_uuid(), p_type, _notif_category(p_type),
    p_title, p_body, coalesce(p_metadata, '{}'), gen_random_uuid())
  on conflict (recipient_uid, event_id) do nothing;
end;
$$;

-- 9. Bucket lifecycle RPCs -----------------------------------------------------
create or replace function request_bucket_delete(p_bucket_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
  v_corr uuid := gen_random_uuid();
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  update buckets
    set status = 'pending_delete', deleted_at = now(), deleted_by = v_uid,
        delete_after = now() + interval '30 days', updated_at = now()
    where id = p_bucket_id and status in ('active', 'archived')
    returning * into v_bucket;
  if v_bucket.id is null then return; end if;
  perform emit_activity(p_bucket_id, 'bucket_deleted', v_uid,
    coalesce(v_bucket.name, 'A bucket') || ' was deleted',
    jsonb_build_object('bucket_name', v_bucket.name), v_corr);
end;
$$;

-- Keep the old name working for old clients: now a soft delete.
create or replace function delete_bucket(p_bucket_id uuid)
returns void language plpgsql security definer set search_path = public as $$
begin
  perform request_bucket_delete(p_bucket_id);
end;
$$;

create or replace function restore_bucket(p_bucket_id uuid)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  update buckets
    set status = 'active', deleted_at = null, deleted_by = null,
        delete_after = null, updated_at = now()
    where id = p_bucket_id and status = 'pending_delete'
    returning * into v_bucket;
  if v_bucket.id is null then
    raise exception 'Bucket is not restorable.' using errcode = 'no_data_found';
  end if;
  perform emit_activity(p_bucket_id, 'bucket_restored', v_uid,
    coalesce(v_bucket.name, 'A bucket') || ' was restored', '{}', gen_random_uuid());
  return v_bucket;
end;
$$;

create or replace function archive_bucket(p_bucket_id uuid, p_archived boolean)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  update buckets
    set status = case when p_archived then 'archived' else 'active' end,
        updated_at = now()
    where id = p_bucket_id and status in ('active', 'archived')
    returning * into v_bucket;
  if v_bucket.id is null then return v_bucket; end if;
  perform emit_activity(p_bucket_id,
    case when p_archived then 'bucket_archived' else 'bucket_restored' end,
    v_uid,
    coalesce(v_bucket.name, 'A bucket')
      || (case when p_archived then ' was archived' else ' was unarchived' end),
    '{}', gen_random_uuid());
  return v_bucket;
end;
$$;

create or replace function remove_member(p_bucket_id uuid, p_user_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_owner uuid;
  v_name text;
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  select owner_id into v_owner from buckets where id = p_bucket_id;
  if p_user_id = v_owner then raise exception 'cannot remove the owner'; end if;
  select name into v_name from users where id = p_user_id;
  delete from bucket_members where bucket_id = p_bucket_id and user_id = p_user_id;
  perform emit_activity(p_bucket_id, 'member_removed', v_uid,
    coalesce(v_name, 'A member') || ' was removed',
    jsonb_build_object('target_uid', p_user_id), gen_random_uuid());
end;
$$;

create or replace function leave_bucket(p_bucket_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_owner uuid;
  v_name text;
begin
  select owner_id into v_owner from buckets where id = p_bucket_id;
  if v_owner is null then raise exception 'bucket not found'; end if;
  if v_uid = v_owner then
    raise exception 'owner_cannot_leave' using errcode = 'P0001';
  end if;
  select name into v_name from users where id = v_uid;
  delete from bucket_members where bucket_id = p_bucket_id and user_id = v_uid;
  perform emit_activity(p_bucket_id, 'member_left', v_uid,
    coalesce(v_name, 'A member') || ' left the bucket', '{}', gen_random_uuid());
end;
$$;

-- Rewrite transfer to route through the pipeline with old/new owner metadata.
create or replace function transfer_bucket_ownership(
  p_bucket_id uuid, p_new_owner uuid)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_old uuid;
  v_bucket buckets;
  v_new_name text;
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  if not exists (
    select 1 from bucket_members
    where bucket_id = p_bucket_id and user_id = p_new_owner
  ) then
    raise exception 'new owner must be a member';
  end if;
  select owner_id into v_old from buckets where id = p_bucket_id;
  update buckets set owner_id = p_new_owner, updated_at = now()
    where id = p_bucket_id returning * into v_bucket;
  update bucket_members set role = 'owner'
    where bucket_id = p_bucket_id and user_id = p_new_owner;
  update bucket_members set role = 'member'
    where bucket_id = p_bucket_id and user_id = v_old;
  select name into v_new_name from users where id = p_new_owner;
  perform emit_activity(p_bucket_id, 'ownership_transferred', v_uid,
    'Ownership transferred to ' || coalesce(v_new_name, 'a member'),
    jsonb_build_object('old_owner', v_old, 'new_owner', p_new_owner),
    gen_random_uuid());
  return v_bucket;
end;
$$;

-- 10. Inbox + activity read RPCs ----------------------------------------------
create or replace function get_bucket_activity(
  p_bucket_id uuid, p_before_created_at timestamptz default null,
  p_before_id uuid default null, p_limit int default 30)
returns setof bucket_activity language plpgsql security definer set search_path = public as $$
begin
  if not is_bucket_member(p_bucket_id) then raise exception 'not a member'; end if;
  return query
    select * from bucket_activity a
    where a.bucket_id = p_bucket_id
      and (p_before_created_at is null
           or (a.created_at, a.id) < (p_before_created_at, p_before_id))
    order by a.created_at desc, a.id desc
    limit least(coalesce(p_limit, 30), 100);
end;
$$;

create or replace function mark_notification_read(p_id uuid)
returns void language sql security definer set search_path = public as $$
  update user_notifications set read_at = coalesce(read_at, now())
    where id = p_id and recipient_uid = auth.uid();
$$;

create or replace function mark_all_notifications_read()
returns void language sql security definer set search_path = public as $$
  update user_notifications set read_at = now()
    where recipient_uid = auth.uid() and read_at is null;
$$;

create or replace function archive_notification(p_id uuid)
returns void language sql security definer set search_path = public as $$
  update user_notifications
    set archived_at = now(), read_at = coalesce(read_at, now())
    where id = p_id and recipient_uid = auth.uid();
$$;

-- 11. Maintenance (retention) --------------------------------------------------
create or replace function advance_bucket_lifecycle()
returns void language plpgsql security definer set search_path = public as $$
begin
  update buckets set status = 'deleted', updated_at = now()
    where status = 'pending_delete' and delete_after is not null
      and delete_after < now();
  delete from buckets
    where status = 'deleted' and delete_after is not null
      and delete_after < now() - interval '90 days';
end;
$$;

create or replace function purge_archived_notifications()
returns void language sql security definer set search_path = public as $$
  delete from user_notifications
    where archived_at is not null and archived_at < now() - interval '90 days';
$$;

do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    begin perform cron.unschedule('me_advance_lifecycle'); exception when others then null; end;
    begin perform cron.unschedule('me_purge_notifications'); exception when others then null; end;
    perform cron.schedule('me_advance_lifecycle', '0 * * * *',
      $sql$ select advance_bucket_lifecycle(); $sql$);
    perform cron.schedule('me_purge_notifications', '30 3 * * *',
      $sql$ select purge_archived_notifications(); $sql$);
  end if;
end $$;
