# Utsav — Scope & Responsibilities

## Role

**Backend / Architecture Lead**

## Responsibilities

You own the backend pipeline and core architecture:

- Supabase setup (auth, database, storage)
- Auth flow (email OTP, phone OTP, Google)
- API routes (`src/app/api/*`)
- Token ledger (append-only writes, balance materialization)
- Fee engine (`calculateFee()` pure function + unit tests)
- Document classifier integration (ONNX in API routes)
- Rate limiting (upstash/ratelimit on all routes)
- Placement/broker logic
- Enforcement/penalty pipeline
- Database schema (Prisma or Supabase migrations)
- Deployment to Vercel

## Files You Own

```
src/lib/auth/           — Supabase client, session utils, role checks
src/lib/verification/   — Classifier inference, verification pipeline
src/lib/token-ledger/   — Ledger writes, balance materialization
src/lib/fee-engine/     — calculateFee() + unit tests
src/lib/enforcement/    — Penalty logic, scheduled jobs
src/lib/placement/      — Placement creation, fee snapshot
src/lib/rate-limit/     — upstash config + middleware
src/app/api/*           — All API route handlers
prisma/                 — Database schema
.env.local              — Environment variables
```

## Handoff Notes

When you finish a piece of work, add a note in `context/utsav/my-notes.md` so reejan knows what API endpoints are ready and what the data shapes look like.

## Merge Protocol

When you complete a feature:
1. Update `context/utsav/my-progress.md`
2. Run `bash scripts/merge-context.sh` to merge into main tracker
3. Commit changes
