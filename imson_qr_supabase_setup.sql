-- IMSON QR PRODUCT SYSTEM - SUPABASE SQL
create extension if not exists "pgcrypto";

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  product_code text not null unique,
  product_name text not null,
  brand text default 'IMSON',
  page_yield text,
  color text default 'Black',
  cartridge_type text default 'Compatible Toner Cartridge',
  description text,
  printer_models text[] default '{}',
  image_url text,
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;

drop policy if exists "Public can view products" on public.products;
create policy "Public can view products"
on public.products for select
to anon, authenticated
using (true);

drop policy if exists "Authenticated admins can insert products" on public.products;
create policy "Authenticated admins can insert products"
on public.products for insert
to authenticated
with check (true);

drop policy if exists "Authenticated admins can update products" on public.products;
create policy "Authenticated admins can update products"
on public.products for update
to authenticated
using (true) with check (true);

drop policy if exists "Authenticated admins can delete products" on public.products;
create policy "Authenticated admins can delete products"
on public.products for delete
to authenticated
using (true);

-- Storage bucket
insert into storage.buckets (id, name, public)
values ('product-images','product-images',true)
on conflict (id) do update set public=true;

drop policy if exists "Public can view product images" on storage.objects;
create policy "Public can view product images"
on storage.objects for select
to public
using (bucket_id='product-images');

drop policy if exists "Authenticated can upload product images" on storage.objects;
create policy "Authenticated can upload product images"
on storage.objects for insert
to authenticated
with check (bucket_id='product-images');

drop policy if exists "Authenticated can update product images" on storage.objects;
create policy "Authenticated can update product images"
on storage.objects for update
to authenticated
using (bucket_id='product-images')
with check (bucket_id='product-images');

drop policy if exists "Authenticated can delete product images" on storage.objects;
create policy "Authenticated can delete product images"
on storage.objects for delete
to authenticated
using (bucket_id='product-images');

-- After running this SQL:
-- Supabase Dashboard > Authentication > Users > Add user
-- Create your admin email/password there.
