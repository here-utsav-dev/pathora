#!/bin/bash
# merge-context.sh — Merges personal progress from utsav/ and reejan/ into main progress-tracker.md
# Run from project root: bash scripts/merge-context.sh

set -e

MAIN="context/progress-tracker.md"
UTSAV="context/utsav/my-progress.md"
REEJAN="context/reejan/my-progress.md"
UTSAV_NOTES="context/utsav/my-notes.md"
REEJAN_NOTES="context/reejan/my-notes.md"
MERGED_LOG="context/merged-history.md"

echo "=== PATHORA Context Merge ==="
echo ""

# Check files exist
for f in "$UTSAV" "$REEJAN"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: $f not found"
    exit 1
  fi
done

# Extract sections from personal files
extract_section() {
  local file="$1"
  local section="$2"
  awk "/^## $section$/,/^## [^$section]/" "$file" | head -n -1 | tail -n +2
}

# Get current date
DATE=$(date +%Y-%m-%d)

# Build merged content
echo "Merging progress from utsav and reejan into $MAIN..."
echo ""

# Create backup
cp "$MAIN" "${MAIN}.bak"

# Read existing main file (everything before "## In Progress")
MAIN_HEADER=$(awk '/^## In Progress/{exit} {print}' "$MAIN" | head -n -1)

# Extract personal progress
UTSAV_COMPLETED=$(extract_section "$UTSAV" "My Completed")
UTSAV_IN_PROGRESS=$(extract_section "$UTSAV" "My In Progress")
UTSAV_NEXT=$(extract_section "$UTSAV" "My Next Up")
UTSAV_BLOCKERS=$(extract_section "$UTSAV" "My Blockers")

REEJAN_COMPLETED=$(extract_section "$REEJAN" "My Completed")
REEJAN_IN_PROGRESS=$(extract_section "$REEJAN" "My In Progress")
REEJAN_NEXT=$(extract_section "$REEJAN" "My Next Up")
REEJAN_BLOCKERS=$(extract_section "$REEJAN" "My Blockers")

# Write merged main file
cat > "$MAIN" << EOF
# Progress Tracker

Update this file whenever the current phase, active feature, or implementation state changes.

## Current Phase

- Phase 0: Project Setup

## Current Goal

- Establish project scaffolding, context files, and development workflow.

## Completed

### Utsav (Backend)
${UTSAV_COMPLETED:-- None yet.}

### Reejan (Frontend)
${REEJAN_COMPLETED:-- None yet.}

## In Progress

### Utsav (Backend)
${UTSAV_IN_PROGRESS:-- None yet.}

### Reejan (Frontend)
${REEJAN_IN_PROGRESS:-- None yet.}

## Next Up

### Utsav (Backend)
${UTSAV_NEXT:-- None yet.}

### Reejan (Frontend)
${REEJAN_NEXT:-- None yet.}

## Blockers

### Utsav
${UTSAV_BLOCKERS:-- None yet.}

### Reejan
${REEJAN_BLOCKERS:-- None yet.}

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

- Last merged: $DATE
- Merge script: bash scripts/merge-context.sh
EOF

echo "Merged main file: $MAIN"
echo ""

# Append to merge history
if [ ! -f "$MERGED_LOG" ]; then
  echo "# Merge History" > "$MERGED_LOG"
  echo "" >> "$MERGED_LOG"
fi

cat >> "$MERGED_LOG" << EOF
## $DATE — Auto-merge
- Utsav completed items merged
- Reejan completed items merged
- Main tracker updated
EOF

echo "Merge history logged: $MERGED_LOG"
echo ""
echo "=== Done ==="
echo ""
echo "Review the merged file:"
echo "  cat $MAIN"
echo ""
echo "Or view differences:"
echo "  diff ${MAIN}.bak $MAIN"
