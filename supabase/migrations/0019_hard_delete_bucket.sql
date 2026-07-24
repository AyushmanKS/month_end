create or replace function request_bucket_delete(p_bucket_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  if (
    select count(*) from bucket_members where bucket_id = p_bucket_id
  ) > 1 then
    raise exception 'bucket_has_members' using errcode = 'P0001';
  end if;
  delete from buckets where id = p_bucket_id;
end;
$$;
