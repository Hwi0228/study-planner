-- STUDYGRADE planner persistence schema
CREATE TABLE IF NOT EXISTS public.planner_data (
  owner_id uuid PRIMARY KEY,
  weeks jsonb NOT NULL DEFAULT '{}'::jsonb
    CHECK (jsonb_typeof(weeks) = 'object'),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Per-account planner storage. Neon Managed Better Auth owns the neon_auth schema.
CREATE TABLE IF NOT EXISTS public.planner_accounts (
  user_id uuid PRIMARY KEY REFERENCES neon_auth."user"(id) ON DELETE CASCADE,
  weeks jsonb NOT NULL DEFAULT '{}'::jsonb
    CHECK (jsonb_typeof(weeks) = 'object'),
  updated_at timestamptz NOT NULL DEFAULT now()
);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.planner_accounts TO studygrade_api;

-- Persisted, revocable read-only links to weekly schedule snapshots.
CREATE TABLE IF NOT EXISTS public.planner_shares (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES neon_auth."user"(id) ON DELETE CASCADE,
  token_hash char(64) NOT NULL UNIQUE CHECK (token_hash ~ '^[0-9a-f]{64}$'),
  week_start date NOT NULL,
  events jsonb NOT NULL CHECK (jsonb_typeof(events) = 'array'),
  created_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz,
  revoked_at timestamptz
);
CREATE INDEX IF NOT EXISTS planner_shares_owner_created_idx
  ON public.planner_shares (owner_id, created_at DESC);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.planner_shares TO studygrade_api;
