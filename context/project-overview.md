# PATHORA

## Overview

PATHORA is a skill-to-employment pipeline platform. It verifies user identity, delivers curated course tracks, tracks progress via a token-based incentive system, calculates placement fees based on performance, and brokers employment opportunities with partner employers.

## Goals

1. Let users sign up with email, phone, or Google and verify their identity (face + document).
2. Let verified users enroll in skill tracks (Cybersecurity, DevOps, etc.) and complete modules.
3. Track progress with an append-only token ledger that rewards learning activity.
4. Calculate placement fees dynamically based on token performance (better performance = lower fee).
5. Broker placements between graduates and partner employers.
6. Provide admin tools for verification review, penalty management, and placement creation.

## Core User Flow

1. User signs up (email, phone, or Google via Supabase Auth).
2. User completes identity verification (selfie + document upload).
3. Document is classified by ONNX model in API route — auto-approved or sent to manual review.
4. On verification, user selects a track and enrolls.
5. User completes modules (quizzes, projects) — each event writes to the token ledger.
6. Dashboard shows live token balance and fee preview via `calculateFee()`.
7. On track completion, user becomes eligible for placement.
8. Admin creates a placement — fee is snapshotted, employer is notified.
9. Student begins payroll-deduction repayment at the snapshotted fee rate.

## Features

### Authentication

- Email OTP, Phone OTP, and Google sign-in via Supabase Auth.
- Rate-limited auth endpoints via upstash/ratelimit.
- Session management via Supabase SSR.

### Verification Pipeline

- Selfie capture with on-device liveness check.
- Document photo upload to Supabase Storage.
- Document classification via ONNX Runtime in Next.js API route.
- Auto-approval above confidence threshold, manual review queue below.
- Admin review queue for flagged documents.

### Course / LMS

- Tracks contain ordered modules (video, doc, quiz, project).
- Modules point to external resources (freeCodeCamp, YouTube, curated docs) — no video hosting.
- Progress tracked via `progress_events` table.
- Dashboard shows completion percentage and next module.

### Token Ledger + Fee Engine

- Append-only `token_ledger` table — never mutate balances directly.
- Materialized `token_balances` updated via Supabase DB function on ledger insert.
- `calculateFee()` is a pure function: client-side for preview, server-side for placement lock-in.
- Fee ranges from 30% (0 tokens) down to 6% (100% tokens).

### Enforcement

- Scheduled job checks enrollments past `target_completion_at` with insufficient progress.
- Issues warnings, course lockouts (7 days), or bans (90 days).
- Middleware checks active penalties before course access.

### Placement / Broker

- Admin creates placements linking user + employer + track.
- On placement: snapshot token %, run `calculateFee()`, store result.
- Employer royalty invoice (stubbed for hackathon).
- Discord bot integration handled by coworker (webhook events from this backend).

### Admin Panel

- Custom `/admin` routes in Next.js.
- Verification queue (approve/reject documents).
- Penalty issuance (warning, lockout, ban).
- Placement creation and management.
- Role-based access via Supabase user metadata.

## Scope

### In Scope (Hackathon)

- Supabase Auth (email/phone/Google)
- Identity verification with ONNX document classifier
- Course enrollment and module progress tracking
- Append-only token ledger with materialized balances
- Fee calculation engine (client preview + server verification)
- Admin panel (verification queue, penalties, placements)
- Rate limiting on all API routes
- Deployment on Vercel

### Out of Scope (Hackathon)

- Discord bot (coworker's domain)
- Real payroll-deduction integration (stubbed)
- Mobile app (web-only for now)
- Video hosting (external links only)
- Production payment rails

## Success Criteria

1. A user can sign up, verify identity, and enroll in a track.
2. Progress events update the token ledger in real-time.
3. Fee preview updates live on the dashboard as tokens increase.
4. Admin can review verification queue and issue penalties.
5. Admin can create a placement that snapshots the fee correctly.
6. All API routes are rate-limited.
7. End-to-end flow works on Vercel deployment.
