-- 0005 — Account deletion + bucket ownership management.

-- Preserve expense/notification history when a user is deleted: null the actor
-- instead of blocking the delete or cascading the rows away.
alter table expenses drop constraint if exists expenses_added_by_uid_fkey;
alter table expenses add constraint expenses_added_by_uid_fkey
  foreign key (added_by_uid) references users(id) on delete set null;

alter table expenses drop constraint if exists expenses_edited_by_uid_fkey;
alter table expenses add constraint expenses_edited_by_uid_fkey
  foreign key (edited_by_uid) references users(id) on delete set null;

alter table big_expenses drop constraint if exists big_expenses_added_by_uid_fkey;
alter table big_expenses add constraint big_expenses_added_by_uid_fkey
  foreign key (added_by_uid) references users(id) on delete set null;

alter table notifications drop constraint if exists notifications_actor_uid_fkey;
alter table notifications add constraint notifications_actor_uid_fkey
  foreign key (actor_uid) references users(id) on delete set null;

create or replace function transfer_bucket_ownership(
  p_bucket_id uuid, p_new_owner uuid)
returns buckets language plpgsql security definer set search_path = public as $$
declare
  v_bucket buckets;
begin
  if not is_bucket_owner(p_bucket_id) then
    raise exception 'not the owner';
  end if;
  if not exists (
    select 1 from bucket_members
    where bucket_id = p_bucket_id and user_id = p_new_owner
  ) then
    raise exception 'new owner must be a member';
  end if;
  update buckets set owner_id = p_new_owner, updated_at = now()
    where id = p_bucket_id
    returning * into v_bucket;
  insert into notifications (bucket_id, type, actor_uid, message)
  values (p_bucket_id, 'ownership_transferred', auth.uid(),
    'Bucket ownership was transferred to a new admin');
  return v_bucket;
end;
$$;

create or replace function delete_bucket(p_bucket_id uuid)
returns void language plpgsql security definer set search_path = public as $$
begin
  if not is_bucket_owner(p_bucket_id) then
    raise exception 'not the owner';
  end if;
  delete from buckets where id = p_bucket_id;
end;
$$;

create or replace function delete_account()
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  if exists (select 1 from buckets where owner_id = v_uid) then
    raise exception 'resolve owned buckets before deleting your account';
  end if;
  insert into notifications (bucket_id, type, actor_uid, message)
  select bucket_id, 'member_left', v_uid,
    'A member left the group by deleting their account'
  from bucket_members where user_id = v_uid;
  delete from auth.users where id = v_uid;
end;
$$;
