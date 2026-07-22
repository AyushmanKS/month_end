-- 0008 — Per-user custom categories.
-- Adds an optional owner to categories: null = global preset (visible to all),
-- non-null = a personal category visible only to its creator. Custom categories
-- live in the categories table so expenses can reference them by foreign key.

alter table categories
  add column if not exists owner_uid uuid references users(id) on delete cascade;

drop policy if exists categories_select_all on categories;
create policy categories_select_preset_or_own on categories
  for select using (is_preset or owner_uid = auth.uid());

create or replace function add_custom_category(p_name text, p_icon text)
returns categories language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_row categories;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  if coalesce(trim(p_name), '') = '' then raise exception 'name required'; end if;

  insert into categories (name, icon, is_preset, owner_uid)
  values (trim(p_name), coalesce(p_icon, 'other'), false, v_uid)
  returning * into v_row;
  return v_row;
end;
$$;

create or replace function delete_custom_category(p_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
begin
  delete from categories
    where id = p_id and is_preset = false and owner_uid = v_uid;
end;
$$;
