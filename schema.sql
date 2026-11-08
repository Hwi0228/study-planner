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
