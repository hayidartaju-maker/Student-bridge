create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(trim(title)) between 1 and 120),
  body text not null check (char_length(trim(body)) between 1 and 2000),
  created_by uuid references auth.users(id) on delete set null,
  is_published boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.announcements enable row level security;

create policy "Anyone authenticated can read published announcements"
on public.announcements for select
to authenticated
using (is_published = true);

create policy "Admins can create announcements"
on public.announcements for insert
to authenticated
with check ((auth.jwt() ->> 'role') = 'admin');

create policy "Admins can delete announcements"
on public.announcements for delete
to authenticated
using ((auth.jwt() ->> 'role') = 'admin');
