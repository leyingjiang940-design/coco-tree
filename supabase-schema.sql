-- 1) Create this table in the Supabase SQL Editor.
create table if not exists public.tree_messages (
  id uuid primary key default gen_random_uuid(),
  nickname text not null check (char_length(nickname) between 1 and 20),
  message text not null check (char_length(message) between 1 and 180),
  score integer not null check (score between 0 and 11),
  color_name text not null,
  owner_reply text,
  created_at timestamptz not null default now()
);

alter table public.tree_messages enable row level security;

-- 2) Replace OWNER_EMAIL_HERE with the email used for the tree owner's Supabase Auth account.
-- Visitors can read public tree notes.
drop policy if exists "Anyone can read tree notes" on public.tree_messages;
create policy "Anyone can read tree notes"
on public.tree_messages for select
using (true);

-- Visitors can add a note, but cannot set an owner reply.
drop policy if exists "Visitors can add tree notes" on public.tree_messages;
create policy "Visitors can add tree notes"
on public.tree_messages for insert
with check (
  char_length(nickname) between 1 and 20
  and char_length(message) between 1 and 180
  and score between 0 and 11
  and owner_reply is null
);

-- Only the configured owner email can update rows (including owner_reply).
drop policy if exists "Only owner can update tree notes" on public.tree_messages;
create policy "Only owner can update tree notes"
on public.tree_messages for update
using ((auth.jwt() ->> 'email') = 'OWNER_EMAIL_HERE')
with check ((auth.jwt() ->> 'email') = 'OWNER_EMAIL_HERE');

grant select on public.tree_messages to anon, authenticated;
grant insert on public.tree_messages to anon, authenticated;
grant update on public.tree_messages to authenticated;
