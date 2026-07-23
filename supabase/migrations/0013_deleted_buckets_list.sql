create or replace function get_deleted_buckets()
returns setof buckets language sql security definer set search_path = public as $$
  select * from buckets
  where owner_id = auth.uid() and status = 'pending_delete'
  order by deleted_at desc;
$$;
