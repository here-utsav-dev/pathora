# Code Standards

## General

- Keep modules small and single-purpose.
- Fix root causes — do not layer workarounds.
- Do not mix unrelated concerns in one component or route.
- Respect the system boundaries defined in `architecture-context.md`.

## TypeScript

- Strict mode is required throughout the project.
- Avoid `any`; use explicit interfaces or narrowly scoped types.
- Validate unknown external input at system boundaries before trusting it.
- Use `interface` for object contracts.

## Next.js

- Default to React Server Components.
- Add `"use client"` only when the component needs browser interactivity, hooks, or real-time state.
- Keep route handlers focused on a single responsibility.
- Long-running work (classifier inference) should have appropriate timeout handling.

## Styling

- Use CSS custom property tokens defined in `globals.css` — no raw Tailwind color classes like `zinc-*` or hardcoded hex values.
- Reference tokens through their Tailwind utility names: `bg-bg-surface`, `text-text-primary`, `border-border-default`, `text-accent-primary`, etc.
- Maintain the border radius scale: `rounded-xl` for small elements, `rounded-2xl` for cards, `rounded-3xl` for modals.

## API Routes

- Validate and parse request input (use Zod) before any logic runs.
- Enforce auth and role checks before any mutation.
- Apply rate limiting via middleware before handler execution.
- Return consistent, predictable response shapes: `{ data, error }`.
- Keep route handlers thin — push logic into `lib/` modules.

## Data and Storage

- All relational data belongs in PostgreSQL via Supabase.
- File uploads (face photos, documents) go to Supabase Storage.
- Do not store binary data in the database — store storage URLs.
- Token ledger is append-only — enforce this at the application level.

## Token Ledger Rules

- Never INSERT with a negative `id` or mutate existing rows.
- Balance is always derived from `SUM(delta)` or the materialized `token_balances`.
- Every ledger write must include a `reason` and `event_ref_id` for auditability.

## Fee Engine Rules

- `calculateFee()` must be a pure function with zero side effects.
- Must have unit tests covering all breakpoints and edge cases.
- Client uses it for preview; server uses it for placement lock-in.
- Both must produce identical results for the same input.

## File Organization

- `src/lib/` — shared infrastructure: auth helpers, business logic, utilities.
- `src/app/api/` — route handlers for auth, verification, progress, placements.
- `src/app/dashboard/` — student-facing dashboard pages.
- `src/app/admin/` — admin-facing pages.
- `src/app/courses/` — course browsing and module pages.
- `src/components/` — UI composition only; no business logic in components.
- `prisma/` — database schema (if using Prisma alongside Supabase).
- Name files after the responsibility they contain, not the technology.
