create table if not exists join_requests (
  id             uuid primary key default gen_random_uuid(),
  bucket_id      uuid not null references buckets(id) on delete cascade,
  bucket_name    text not null default '',
  requester_uid  uuid not null references users(id) on delete cascade,
  requester_name text,
  requester_photo text,
  status         text not null default 'pending',
  decided_by_uid uuid references users(id),
  created_at     timestamptz default now(),
  decided_at     timestamptz
);

create unique index if not exists uq_join_requests_pending
  on join_requests(bucket_id, requester_uid) where status = 'pending';
create index if not exists idx_join_requests_bucket
  on join_requests(bucket_id, status);
create index if not exists idx_join_requests_requester
  on join_requests(requester_uid, status);

alter table join_requests enable row level security;

drop policy if exists join_requests_select on join_requests;
create policy join_requests_select on join_requests
  for select using (requester_uid = auth.uid() or is_bucket_owner(bucket_id));

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'join_requests'
  ) then
    alter publication supabase_realtime add table join_requests;
  end if;
end $$;

create or replace function request_join(p_id uuid, p_code text)
returns join_requests language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
  v_req join_requests;
  v_name text;
  v_photo text;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;

  if p_id is not null then
    select * into v_req from join_requests where id = p_id;
    if v_req.id is not null then return v_req; end if;
  end if;

  select * into v_bucket from buckets where join_code = upper(p_code);
  if v_bucket.id is null then
    raise exception 'No bucket found for that code.' using errcode = 'no_data_found';
  end if;

  if exists (
    select 1 from bucket_members
    where bucket_id = v_bucket.id and user_id = v_uid
  ) then
    raise exception 'already_member' using errcode = 'P0001';
  end if;

  select * into v_req from join_requests
    where bucket_id = v_bucket.id and requester_uid = v_uid and status = 'pending';
  if v_req.id is not null then return v_req; end if;

  select name, photo_url into v_name, v_photo from users where id = v_uid;

  insert into join_requests (
    id, bucket_id, bucket_name, requester_uid, requester_name,
    requester_photo, status)
  values (
    coalesce(p_id, gen_random_uuid()), v_bucket.id, v_bucket.name, v_uid,
    v_name, v_photo, 'pending')
  returning * into v_req;

  perform _notify(
    v_bucket.id,
    'join_requested',
    coalesce(v_name, 'Someone') || ' asked to join this bucket');

  return v_req;
end;
$$;

create or replace function decide_join_request(p_request_id uuid, p_accept boolean)
returns join_requests language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_req join_requests;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;

  select * into v_req from join_requests where id = p_request_id;
  if v_req.id is null then
    raise exception 'Request not found.' using errcode = 'no_data_found';
  end if;
  if not is_bucket_owner(v_req.bucket_id) then
    raise exception 'not the owner';
  end if;
  if v_req.status <> 'pending' then return v_req; end if;

  if p_accept then
    insert into bucket_members (bucket_id, user_id)
    values (v_req.bucket_id, v_req.requester_uid)
    on conflict do nothing;
    update join_requests
      set status = 'accepted', decided_by_uid = v_uid, decided_at = now()
      where id = p_request_id
      returning * into v_req;
    perform _notify(
      v_req.bucket_id,
      'member_joined',
      coalesce(v_req.requester_name, 'A new member') || ' joined this bucket');
  else
    update join_requests
      set status = 'rejected', decided_by_uid = v_uid, decided_at = now()
      where id = p_request_id
      returning * into v_req;
  end if;

  return v_req;
end;
$$;

create or replace function cancel_join_request(p_request_id uuid)
returns join_requests language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_req join_requests;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;

  select * into v_req from join_requests where id = p_request_id;
  if v_req.id is null then
    raise exception 'Request not found.' using errcode = 'no_data_found';
  end if;
  if v_req.requester_uid <> v_uid then
    raise exception 'not your request';
  end if;
  if v_req.status = 'pending' then
    update join_requests
      set status = 'cancelled', decided_at = now()
      where id = p_request_id
      returning * into v_req;
  end if;

  return v_req;
end;
$$;
