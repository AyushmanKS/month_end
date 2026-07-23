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

create or replace function delete_account()
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket uuid;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  if exists (
    select 1 from buckets
    where owner_id = v_uid and status in ('active', 'archived')
  ) then
    raise exception 'resolve owned buckets before deleting your account';
  end if;
  for v_bucket in
    select bucket_id from bucket_members where user_id = v_uid
  loop
    perform emit_activity(
      v_bucket, 'member_left', v_uid,
      'A member left by deleting their account');
  end loop;
  delete from auth.users where id = v_uid;
end;
$$;
