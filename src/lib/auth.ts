export type SessionUser = {
  id: string;
  email: string;
  roles: string[];
};

export async function requireSession(): Promise<SessionUser> {
  // Placeholder integration point for Supabase SSR auth helper.
  // Throw to enforce guarded server actions.
  throw new Error('Implement Supabase session resolver in src/lib/auth.ts');
}
