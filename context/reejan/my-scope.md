# Reejan — Scope & Responsibilities

## Role

**Frontend / UI Lead**

## Responsibilities

You own the user-facing interface and all UI components:

- Dashboard (student view: progress, token balance, fee preview)
- Course browsing and module pages
- Admin panel (verification queue, penalties, placements)
- Auth pages (login, signup, OTP verification screens)
- All `src/components/*` (dashboard, admin, courses)
- UI polish, responsive design, animations
- Integration with API endpoints (fetch calls from client components)

## Files You Own

```
src/app/dashboard/*      — Student dashboard pages
src/app/courses/*        — Course listing and module pages
src/app/admin/*          — Admin panel pages
src/app/auth/*           — Login, signup, OTP screens
src/components/dashboard/* — Dashboard-specific components
src/components/admin/*     — Admin-specific components
src/components/courses/*   — Course-specific components
src/app/globals.css      — Theme tokens (coordinate with utsav)
```

## Handoff Notes

When you need an API endpoint or data shape, add a request in `context/reejan/my-notes.md` so utsav knows what to build.

## Merge Protocol

When you complete a feature:
1. Update `context/reejan/my-progress.md`
2. Run `bash scripts/merge-context.sh` to merge into main tracker
3. Commit changes
