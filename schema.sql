-- STUDYGRADE planner persistence schema
CREATE TABLE IF NOT EXISTS public.planner_data (
  owner_id uuid PRIMARY KEY,
  weeks jsonb NOT NULL DEFAULT '{}'::jsonb
    CHECK (jsonb_typeof(weeks) = 'object'),
  updated_at timestamptz NOT NULL DEFAULT now()
);
