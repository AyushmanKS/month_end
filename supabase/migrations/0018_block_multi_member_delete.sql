create or replace function request_bucket_delete(p_bucket_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_bucket buckets;
  v_corr uuid := gen_random_uuid();
begin
  if not is_bucket_owner(p_bucket_id) then raise exception 'not the owner'; end if;
  if (
    select count(*) from bucket_members where bucket_id = p_bucket_id
  ) > 1 then
    raise exception 'bucket_has_members' using errcode = 'P0001';
  end if;
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
