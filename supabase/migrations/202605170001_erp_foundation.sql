-- ERP Manufacturing Foundation Schema
create extension if not exists pgcrypto;

create table if not exists roles (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid
);

create table if not exists permissions (
  id uuid primary key default gen_random_uuid(),
  module text not null,
  action text not null check (action in ('create','read','update','delete','approve','export')),
  unique(module, action),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid
);

create table if not exists users (
  id uuid primary key,
  email text unique not null,
  full_name text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid
);

create table if not exists role_permissions (
  id uuid primary key default gen_random_uuid(),
  role_id uuid not null references roles(id),
  permission_id uuid not null references permissions(id),
  unique(role_id, permission_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid
);

create table if not exists user_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id),
  role_id uuid not null references roles(id),
  unique(user_id, role_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid
);

create table if not exists product_categories (
  id uuid primary key default gen_random_uuid(), name text not null unique,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists products (
  id uuid primary key default gen_random_uuid(), sku text unique not null, name text not null,
  category_id uuid references product_categories(id), uom text not null, reorder_point numeric(18,4) not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists materials (
  id uuid primary key default gen_random_uuid(), code text unique not null, name text not null, uom text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists warehouses (
  id uuid primary key default gen_random_uuid(), code text unique not null, name text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists warehouse_locations (
  id uuid primary key default gen_random_uuid(), warehouse_id uuid not null references warehouses(id), code text not null, name text not null, unique(warehouse_id,code),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists stock_movements (
  id uuid primary key default gen_random_uuid(), movement_type text not null check (movement_type in ('IN','OUT','ADJUSTMENT','TRANSFER')),
  product_id uuid references products(id), material_id uuid references materials(id), warehouse_location_id uuid not null references warehouse_locations(id),
  batch_no text, qty numeric(18,4) not null, reference_no text, notes text,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid,
  check ((product_id is not null) <> (material_id is not null))
);

create table if not exists suppliers (
  id uuid primary key default gen_random_uuid(), code text unique not null, name text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists purchase_requests (
  id uuid primary key default gen_random_uuid(), request_no text unique not null, status text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists purchase_orders (
  id uuid primary key default gen_random_uuid(), po_no text unique not null, supplier_id uuid not null references suppliers(id), status text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists purchase_order_items (
  id uuid primary key default gen_random_uuid(), purchase_order_id uuid not null references purchase_orders(id), material_id uuid not null references materials(id), qty numeric(18,4) not null, price numeric(18,2) not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists goods_receipts (
  id uuid primary key default gen_random_uuid(), gr_no text unique not null, purchase_order_id uuid not null references purchase_orders(id), status text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);

create table if not exists bom (
  id uuid primary key default gen_random_uuid(), product_id uuid not null references products(id), revision text not null, is_active boolean not null default true,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists bom_items (
  id uuid primary key default gen_random_uuid(), bom_id uuid not null references bom(id), material_id uuid not null references materials(id), qty numeric(18,4) not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists work_orders (
  id uuid primary key default gen_random_uuid(), wo_no text unique not null, product_id uuid not null references products(id), planned_qty numeric(18,4) not null, status text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists production_logs (
  id uuid primary key default gen_random_uuid(), work_order_id uuid not null references work_orders(id), produced_qty numeric(18,4) not null default 0, reject_qty numeric(18,4) not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);

create table if not exists machine_categories (
  id uuid primary key default gen_random_uuid(), name text unique not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists machines (
  id uuid primary key default gen_random_uuid(), code text unique not null, name text not null, category_id uuid references machine_categories(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists maintenance_logs (
  id uuid primary key default gen_random_uuid(), machine_id uuid not null references machines(id), maintenance_type text not null, downtime_minutes int not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists spareparts (
  id uuid primary key default gen_random_uuid(), code text unique not null, name text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);

create table if not exists qc_inspections (
  id uuid primary key default gen_random_uuid(), inspection_no text unique not null, work_order_id uuid references work_orders(id), status text not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);
create table if not exists qc_results (
  id uuid primary key default gen_random_uuid(), inspection_id uuid not null references qc_inspections(id), parameter_name text not null, result_value text, is_pass boolean not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(), actor_id uuid, module text not null, action text not null, entity text not null, entity_id uuid, before_data jsonb, after_data jsonb,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz, created_by uuid, updated_by uuid
);

create index if not exists idx_stock_movements_created_at on stock_movements(created_at desc);
create index if not exists idx_stock_movements_product_location on stock_movements(product_id, warehouse_location_id);
create index if not exists idx_work_orders_status on work_orders(status);
create index if not exists idx_production_logs_work_order on production_logs(work_order_id);
create index if not exists idx_maintenance_logs_machine on maintenance_logs(machine_id);
create index if not exists idx_audit_logs_module_created on audit_logs(module, created_at desc);
