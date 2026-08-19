# Architecture Context

## Stack

| Layer            | Technology                    | Role                                                        |
| ---------------- | ----------------------------- | ----------------------------------------------------------- |
| Framework        | Next.js 16 + TypeScript       | Full-stack app with server/client boundaries                |
| UI               | Tailwind + shadcn/ui          | Component composition and styling                           |
| Auth             | Supabase Auth                 | Email OTP, Phone OTP, Google sign-in                        |
| Database         | Supabase (PostgreSQL)         | All relational data: users, verifications, tracks, tokens   |
| File storage     | Supabase Storage              | ID docs, face photos, classifier model artifacts            |
| Classifier       | ONNX Runtime (Node)           | Document type classification in API routes                  |
| Rate limiting    | upstash/ratelimit + Redis     | Sliding window rate limiting on all API routes              |
| Email            | Resend                        | OTP emails, notifications, employer alerts                  |
| Admin            | Custom Next.js `/admin` routes| Verification queue, penalties, placements                   |
| Deployment       | Vercel                        | Serverless functions, edge middleware                       |
| Monitoring       | Sentry (free tier)            | Error tracking                                              |

## System Boundaries

```
src/
  app/
    api/           — Authenticated request handlers: validation, auth checks, mutations
    auth/          — Login/signup pages (email, phone, Google)
    dashboard/     — Student dashboard: progress, token balance, fee preview
    courses/       — Track listing, module detail, quiz submission
    admin/         — Verification queue, penalty management, placement creation
  lib/
    auth/          — Supabase client helpers, session utils, role checks
    verification/  — Classifier inference, verification pipeline logic
    lms/           — Track/module CRUD, enrollment logic, progress events
    token-ledger/  — Append-only ledger writes, balance materialization
    fee-engine/    — calculateFee() pure function + unit tests
    enforcement/   — Penalty checks, scheduled job logic
    placement/     — Placement creation, fee snapshot, employer webhook
    rate-limit/    — upstash/ratelimit configuration and middleware
  components/
    ui/            — shadcn/ui foundation components (DO NOT MODIFY directly)
    dashboard/     — Dashboard-specific components
    admin/         — Admin-specific components
    courses/       — Course-specific components
  prisma/          — Schema (if using Prisma alongside Supabase)
```

## Storage Model

- **PostgreSQL (Supabase)**: All relational data — users, verifications, tracks, modules, enrollments, progress_events, token_ledger, token_balances, penalties, employers, placements.
- **Supabase Storage**: Uploaded files — face photos at `faces/{userId}.jpg`, documents at `docs/{userId}/{type}.jpg`.
- **File URL references**: Storage paths stored in `verifications.file_url` column. Never store binary data in PostgreSQL.

## Data Model

### Core Tables

```
users
  id (uuid, PK), phone, email, name, dob, status, created_at
  status: pending_verification | verified | enrolled | warned | banned | placed

verifications
  id (uuid, PK), user_id (FK), type, file_url, classifier_label,
  classifier_confidence, review_status, reviewed_by, reviewed_at
  type: face | birth_cert | citizenship_id
  review_status: auto_pending | manual_review | approved | rejected

tracks
  id (uuid, PK), name, description

modules
  id (uuid, PK), track_id (FK), title, order_index, resource_url, resource_type
  resource_type: video | doc | quiz | project

enrollments
  id (uuid, PK), user_id (FK), track_id (FK), status, started_at, target_completion_at
  status: active | paused_penalty | completed | dropped

progress_events
  id (uuid, PK), user_id (FK), module_id (FK), event_type, score, created_at
  event_type: started | quiz_passed | quiz_failed | project_submitted |
             project_approved | doubt_solved | doubt_asked

token_ledger (APPEND-ONLY)
  id (uuid, PK), user_id (FK), track_id (FK), delta, reason, event_ref_id, created_at

token_balances (MATERIALIZED — updated via DB function)
  user_id (FK), track_id (FK), current_tokens, max_possible_tokens, pct

penalties
  id (uuid, PK), user_id (FK), type, reason, starts_at, ends_at, issued_by
  type: warning | course_lockout | ban

employers
  id (uuid, PK), name, contact_email, sector, active

placements
  id (uuid, PK), user_id (FK), employer_id (FK), track_id (FK), salary,
  placed_at, employer_royalty_amount, employer_royalty_status,
  student_fee_pct, student_fee_status
  student_fee_status: pending_payroll_setup | active | completed
```

## Auth and Access Model

- Supabase Auth handles identity (email/phone/Google).
- User role stored in Supabase user metadata (`role: "admin" | "student"`).
- Middleware on `/admin/*` routes checks admin role.
- Middleware on `/api/*` routes checks authenticated session.
- Rate limiting applied at middleware layer before auth checks.

## Invariants

1. Token ledger is append-only — never update or delete rows. Balance is always recomputed from ledger.
2. `calculateFee()` is a pure function — no side effects, fully unit-testable.
3. Fee is only "locked in" at placement creation — before that, dashboard shows live preview.
4. Document classifier runs in-process (ONNX in Node) — no external Python service.
5. Every API route has rate limiting — no exceptions.
6. Admin routes require admin role check — enforced at middleware level.
7. File uploads go to Supabase Storage — never stored in the database directly.
8. Penalties are checked via middleware — single source of truth, no scattered checks.
