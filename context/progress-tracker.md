# Progress Tracker

Update this file whenever the current phase, active feature, or implementation state changes.

**This file is auto-merged from personal trackers.** Run `bash scripts/merge-context.sh` to update.

## Current Phase

- Phase 0: Project Setup

## Current Goal

- Establish project scaffolding, context files, and team workflow.

## Completed

### Utsav (Backend)
- Project scaffolding (Next.js 16, TypeScript, Tailwind)
- Context files created
- Directory structure established

### Reejan (Frontend)
- Dark theme tokens defined in globals.css
- UI context file created (colors, typography, layout patterns)

## In Progress

### Utsav (Backend)
- None yet.

### Reejan (Frontend)
- None yet.

## Next Up

### Utsav (Backend)
- Install dependencies: `@supabase/supabase-js`, `@supabase/ssr`, `@upstash/ratelimit`, `@upstash/redis`, `resend`, `onnxruntime-node`, `zod`
- Set up Supabase project and `.env.local`
- Create database schema
- Implement auth flow
- Build token ledger append-only writes
- Build fee engine with unit tests
- Wire up rate limiting middleware

### Reejan (Frontend)
- Install shadcn/ui and add base components
- Build auth pages (login, signup, OTP screens)
- Build student dashboard layout
- Build dashboard components (token balance, fee preview, progress bar)
- Build course listing page
- Build admin panel layout
- Build admin verification queue UI
- Build admin penalty management UI
- Build admin placement creation UI

## Blockers

### Utsav
- None yet.

### Reejan
- Need API endpoints from utsav before building data-fetching components
- Need Supabase auth setup before building auth pages

## Open Questions

- Should we use Prisma alongside Supabase, or use Supabase's native SQL editor for migrations?
- What is the exact ONNX model format for the document classifier?
- How many sample images do we have for classifier training?
- What is the Discord webhook URL format that the coworker's bot expects?

## Architecture Decisions

- Web-only for hackathon (Next.js), mobile app deferred.
- Token ledger is append-only from day one — no shortcuts.
- calculateFee() is a pure function, client + server verified.
- Document classifier runs in Next.js API routes via ONNX Runtime (no Python).
- Admin panel is custom Next.js routes, not Retool.
- Discord bot integration is a webhook stub — coworker handles the bot.
- Rate limiting via upstash/ratelimit on all API routes.
- Auth via Supabase: email OTP + phone OTP + Google.

## Session Notes

- Last merged: 2026-08-19
- Merge script: `bash scripts/merge-context.sh`
