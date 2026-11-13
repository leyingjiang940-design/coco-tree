-- 椰子的圣诞树：共享留言 + 主人回复
-- 此 SQL 对应 coconut-christmas Supabase 项目。
-- 将 OWNER_EMAIL_HERE 替换为椰子用于 Supabase Auth 登录的邮箱后，再执行 owner_email UPDATE。

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table if not exists private.tree_owner (
  singleton boolean primary key default true check (singleton),
  owner_user_id uuid unique references auth.users(id) on delete set null,
  owner_email text
);
insert into private.tree_owner(singleton, owner_user_id, owner_email)
values (true, null, null)
on conflict (singleton) do nothing;
alter table private.tree_owner enable row level security;
revoke all on private.tree_owner from public, anon, authenticated;
drop policy if exists "Deny direct access to owner registry" on private.tree_owner;
create policy "Deny direct access to owner registry"
on private.tree_owner for all to public
using (false) with check (false);

create or replace function private.is_tree_owner()
returns boolean
language sql stable security definer
set search_path = ''
as $$
  select exists (
    select 1 from private.tree_owner
    where singleton = true
      and owner_email is not null
      and lower(owner_email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
revoke all on function private.is_tree_owner() from public, anon;
grant execute on function private.is_tree_owner() to authenticated;

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
revoke all on table public.tree_messages from public, anon, authenticated;
grant select, insert on public.tree_messages to anon, authenticated;
grant update (owner_reply) on public.tree_messages to authenticated;

drop policy if exists "Anyone can read tree notes" on public.tree_messages;
create policy "Anyone can read tree notes"
on public.tree_messages for select to anon, authenticated using (true);

drop policy if exists "Visitors can add tree notes" on public.tree_messages;
create policy "Visitors can add tree notes"
on public.tree_messages for insert to anon, authenticated
with check (
  char_length(nickname) between 1 and 20
  and char_length(message) between 1 and 180
  and score between 0 and 11
  and owner_reply is null
);

drop policy if exists "Only owner can update tree notes" on public.tree_messages;
create policy "Only owner can update tree notes"
on public.tree_messages for update to authenticated
using ((select private.is_tree_owner()))
with check ((select private.is_tree_owner()));

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'tree_messages'
  ) then
    alter publication supabase_realtime add table public.tree_messages;
  end if;
end $$;

-- Auth email address must be verified before the owner can log in.
-- After registering the owner account, execute:
-- update private.tree_owner set owner_email = lower('OWNER_EMAIL_HERE') where singleton = true;
