insert into bucket_members (bucket_id, user_id, role)
  select b.id, b.owner_id, 'owner'
  from buckets b
  where not exists (
    select 1 from bucket_members m
    where m.bucket_id = b.id and m.user_id = b.owner_id
  );

create or replace function is_bucket_member(target_bucket uuid)
returns boolean language sql security definer set search_path = public as $$
  select exists (
    select 1 from bucket_members
    where bucket_id = target_bucket and user_id = auth.uid()
  ) or exists (
    select 1 from buckets
    where id = target_bucket and owner_id = auth.uid()
  );
$$;
