create extension if not exists "pgcrypto";

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique
);

create table if not exists public.channels (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  logo text,
  stream_url text not null,
  category text references public.categories(name) on update cascade on delete set null,
  country text,
  language text,
  created_at timestamptz not null default now()
);

create table if not exists public.favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  channel_id uuid not null references public.channels(id) on delete cascade,
  unique (user_id, channel_id)
);

create table if not exists public.watch_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  channel_id uuid not null references public.channels(id) on delete cascade,
  watched_at timestamptz not null default now()
);

create index if not exists channels_category_idx on public.channels(category);
create index if not exists channels_country_idx on public.channels(country);
create index if not exists favorites_user_id_idx on public.favorites(user_id);
create index if not exists watch_history_user_id_watched_at_idx
  on public.watch_history(user_id, watched_at desc);

alter table public.categories enable row level security;
alter table public.channels enable row level security;
alter table public.favorites enable row level security;
alter table public.watch_history enable row level security;

drop policy if exists "Categories are public read-only" on public.categories;
create policy "Categories are public read-only"
  on public.categories for select
  using (true);

drop policy if exists "Channels are public read-only" on public.channels;
create policy "Channels are public read-only"
  on public.channels for select
  using (true);

drop policy if exists "Users can read their favorites" on public.favorites;
create policy "Users can read their favorites"
  on public.favorites for select
  using (auth.uid() = user_id);

drop policy if exists "Users can add their favorites" on public.favorites;
create policy "Users can add their favorites"
  on public.favorites for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their favorites" on public.favorites;
create policy "Users can delete their favorites"
  on public.favorites for delete
  using (auth.uid() = user_id);

drop policy if exists "Users can read their watch history" on public.watch_history;
create policy "Users can read their watch history"
  on public.watch_history for select
  using (auth.uid() = user_id);

drop policy if exists "Users can add their watch history" on public.watch_history;
create policy "Users can add their watch history"
  on public.watch_history for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their watch history" on public.watch_history;
create policy "Users can delete their watch history"
  on public.watch_history for delete
  using (auth.uid() = user_id);

insert into public.categories (name)
values ('News'), ('Sports'), ('Education'), ('Culture'), ('General')
on conflict (name) do nothing;
