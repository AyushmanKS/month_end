-- month_end shared expense bucket app — schema
-- Run against your Supabase project via the SQL editor or `supabase db push`.

create extension if not exists "pgcrypto";

create table if not exists users (
  id                uuid primary key references auth.users(id) on delete cascade,
  name              text,
  photo_url         text,
  auth_type         text default 'anonymous',
  email             text,
  username          text unique,
  custom_categories jsonb default '[]'::jsonb,
  created_at        timestamptz default now()
);

create table if not exists buckets (
  id                    uuid primary key default gen_random_uuid(),
  name                  text not null,
  owner_id              uuid not null references users(id) on delete cascade,
  join_code             text unique not null,
  monthly_budget        numeric not null default 0,
  month_start_date      date not null,
  remaining_main_bucket numeric not null default 0,
  created_at            timestamptz default now(),
  updated_at            timestamptz default now()
);

create table if not exists bucket_members (
  bucket_id uuid references buckets(id) on delete cascade,
  user_id   uuid references users(id) on delete cascade,
  joined_at timestamptz default now(),
  primary key (bucket_id, user_id)
);

create table if not exists weekly_buckets (
  id               uuid primary key default gen_random_uuid(),
  bucket_id        uuid references buckets(id) on delete cascade,
  week_index       int not null,
  start_date       date not null,
  end_date         date not null,
  allocated_amount numeric not null default 0,
  spent_amount     numeric not null default 0,
  remaining_amount numeric not null default 0,
  status           text not null default 'active'
);

create table if not exists categories (
  id        uuid primary key default gen_random_uuid(),
  name      text not null,
  icon      text not null,
  is_preset boolean default true
);

create table if not exists expenses (
  id                uuid primary key default gen_random_uuid(),
  bucket_id         uuid references buckets(id) on delete cascade,
  week_id           uuid references weekly_buckets(id) on delete set null,
  added_by_uid      uuid references users(id),
  amount            numeric not null,
  category_id       uuid references categories(id) on delete set null,
  note              text,
  receipt_image_url text,
  created_at        timestamptz default now(),
  updated_at        timestamptz default now(),
  edited_by_uid     uuid references users(id)
);

create table if not exists big_expenses (
  id           uuid primary key default gen_random_uuid(),
  bucket_id    uuid references buckets(id) on delete cascade,
  added_by_uid uuid references users(id),
  title        text not null,
  amount       numeric not null,
  created_at   timestamptz default now()
);

create table if not exists notifications (
  id         uuid primary key default gen_random_uuid(),
  bucket_id  uuid references buckets(id) on delete cascade,
  type       text not null,
  actor_uid  uuid references users(id),
  message    text not null,
  created_at timestamptz default now(),
  read_by    uuid[] default '{}'
);

create table if not exists suggestions (
  id             uuid primary key default gen_random_uuid(),
  bucket_id      uuid references buckets(id) on delete cascade,
  week_id        uuid references weekly_buckets(id) on delete cascade,
  category_id    uuid references categories(id) on delete set null,
  message        text not null,
  percent_change numeric,
  created_at     timestamptz default now()
);

create index if not exists idx_bucket_members_user on bucket_members(user_id);
create index if not exists idx_expenses_bucket on expenses(bucket_id);
create index if not exists idx_weekly_bucket on weekly_buckets(bucket_id);
create index if not exists idx_notifications_bucket on notifications(bucket_id);
create index if not exists idx_suggestions_bucket on suggestions(bucket_id);
