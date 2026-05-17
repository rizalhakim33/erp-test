export const ROLE_CODES = [
  'super_admin',
  'owner',
  'manager',
  'purchasing',
  'warehouse',
  'production',
  'qc',
  'maintenance',
] as const;

export const PERMISSION_ACTIONS = ['create', 'read', 'update', 'delete', 'approve', 'export'] as const;

export type RoleCode = (typeof ROLE_CODES)[number];
export type PermissionAction = (typeof PERMISSION_ACTIONS)[number];

export type ModulePermission = `${string}:${PermissionAction}`;

export const RBAC_MATRIX: Record<RoleCode, ModulePermission[]> = {
  super_admin: ['*:create', '*:read', '*:update', '*:delete', '*:approve', '*:export'],
  owner: ['*:read', 'dashboard:export', 'finance:approve'],
  manager: ['inventory:read', 'purchasing:approve', 'production:approve', 'qc:approve'],
  purchasing: ['purchasing:create', 'purchasing:read', 'purchasing:update'],
  warehouse: ['inventory:create', 'inventory:read', 'inventory:update'],
  production: ['production:create', 'production:read', 'production:update'],
  qc: ['qc:create', 'qc:read', 'qc:update', 'qc:approve'],
  maintenance: ['maintenance:create', 'maintenance:read', 'maintenance:update'],
};
