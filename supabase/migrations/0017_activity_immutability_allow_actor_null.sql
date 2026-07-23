create or replace function _forbid_activity_mutation()
returns trigger language plpgsql as $$
begin
  if new.id is distinct from old.id
     or new.bucket_id is distinct from old.bucket_id
     or new.type is distinct from old.type
     or new.category is distinct from old.category
     or new.summary is distinct from old.summary
     or new.metadata is distinct from old.metadata
     or new.correlation_id is distinct from old.correlation_id
     or new.created_at is distinct from old.created_at then
    raise exception 'bucket_activity is append-only';
  end if;
  return new;
end;
$$;
