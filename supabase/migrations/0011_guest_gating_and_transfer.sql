create or replace function _is_anonymous_caller()
returns boolean language sql stable as $$
  select coalesce((auth.jwt() ->> 'is_anonymous')::boolean, false);
$$;

create or replace function _is_anonymous_owner(p_bucket_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from buckets b join users u on u.id = b.owner_id
    where b.id = p_bucket_id and u.auth_type = 'anonymous'
  );
$$;

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
  if _is_anonymous_caller() then
    raise exception 'auth_required' using errcode = 'P0001';
  end if;

  if p_id is not null then
    select * into v_req from join_requests where id = p_id;
    if v_req.id is not null then return v_req; end if;
  end if;

  select * into v_bucket from buckets where join_code = upper(p_code);
  if v_bucket.id is null then
    raise exception 'No bucket found for that code.' using errcode = 'no_data_found';
  end if;

  if _is_anonymous_owner(v_bucket.id) then
    raise exception 'owner_not_shareable' using errcode = 'P0001';
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

create or replace function join_bucket_with_code(p_code text)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  if _is_anonymous_caller() then
    raise exception 'auth_required' using errcode = 'P0001';
  end if;
  select * into v_bucket from buckets where join_code = upper(p_code);
  if v_bucket.id is null then
    raise exception 'No bucket found for that code.' using errcode = 'no_data_found';
  end if;
  if _is_anonymous_owner(v_bucket.id) then
    raise exception 'owner_not_shareable' using errcode = 'P0001';
  end if;
  insert into bucket_members (bucket_id, user_id)
  values (v_bucket.id, v_uid)
  on conflict do nothing;
  return v_bucket;
end;
$$;

create table if not exists pending_bucket_transfers (
  token      uuid primary key default gen_random_uuid(),
  anon_uid   uuid not null references users(id) on delete cascade,
  created_at timestamptz default now()
);

alter table pending_bucket_transfers enable row level security;

create or replace function stage_bucket_transfer()
returns uuid language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_token uuid;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  delete from pending_bucket_transfers
    where created_at < now() - interval '1 hour';
  insert into pending_bucket_transfers (anon_uid)
  values (v_uid)
  returning token into v_token;
  return v_token;
end;
$$;

create or replace function claim_bucket_transfer(p_token uuid)
returns integer language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_anon uuid;
  v_count integer := 0;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;

  select anon_uid into v_anon from pending_bucket_transfers
    where token = p_token and created_at > now() - interval '1 hour';
  if v_anon is null then return 0; end if;

  delete from pending_bucket_transfers where token = p_token;
  if v_anon = v_uid then return 0; end if;

  update buckets set owner_id = v_uid, updated_at = now()
    where owner_id = v_anon;
  get diagnostics v_count = row_count;

  insert into bucket_members (bucket_id, user_id)
    select id, v_uid from buckets where owner_id = v_uid
    on conflict do nothing;

  delete from bucket_members bm using buckets b
    where bm.bucket_id = b.id and b.owner_id = v_uid and bm.user_id = v_anon;

  return v_count;
end;
$$;
