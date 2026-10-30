-- Mes Finances : tables et sécurité
-- À coller dans Supabase > SQL Editor > New query, puis "Run".

create table if not exists public.accounts (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name        text not null,
  kind        text not null default 'courant',
  initial     numeric(14,2) not null default 0,
  sort        int not null default 0,
  created_at  timestamptz not null default now()
);

create table if not exists public.transactions (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null default auth.uid() references auth.users(id) on delete cascade,
  type           text not null check (type in ('expense','income','transfer')),
  amount         numeric(14,2) not null check (amount > 0),
  account_id     uuid not null references public.accounts(id) on delete restrict,
  to_account_id  uuid references public.accounts(id) on delete restrict,
  category       text,
  date           date not null,
  note           text,
  created_at     timestamptz not null default now()
);
create index if not exists transactions_user_date on public.transactions (user_id, date desc);

create table if not exists public.budgets (
  user_id        uuid not null default auth.uid() references auth.users(id) on delete cascade,
  category       text not null,
  monthly_limit  numeric(14,2) not null check (monthly_limit > 0),
  primary key (user_id, category)
);

-- Chaque utilisateur ne voit et ne modifie que ses propres lignes
alter table public.accounts     enable row level security;
alter table public.transactions enable row level security;
alter table public.budgets      enable row level security;

drop policy if exists "own rows" on public.accounts;
drop policy if exists "own rows" on public.transactions;
drop policy if exists "own rows" on public.budgets;

create policy "own rows" on public.accounts     for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on public.transactions for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on public.budgets      for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
