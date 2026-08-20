<!-- BEGIN:nextjs-agent-rules -->

# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->

## Application Building Context

Read the following files in order before implementing or making any architectural decision:

1. `context/project-overview.md` — product definition, goals, features, and scope
2. `context/architecture-context.md` — system structure, boundaries, storage model, and invariants
3. `context/ui-context.md` — theme, colors, typography, and component conventions
4. `context/code-standards.md` — implementation rules and conventions
5. `context/ai-workflow-rules.md` — development workflow, scoping rules, and delivery approach
6. `context/progress-tracker.md` — current phase, completed work, open questions, and next steps

Update `context/progress-tracker.md` after each meaningful implementation change.

If implementation changes the architecture, scope, or standards documented in the context files, update the relevant file before continuing.

## Team Workflow (Utsav + Reejan + Roshan)

### Who Does What

| Person | Folder | Role | Owns |
|--------|--------|------|------|
| **Utsav** | `context/utsav/` | Backend / Architecture Lead | Auth, API routes, token ledger, fee engine, classifier, rate limiting, DB schema, deployment |
| **Reejan** | `context/reejan/` | Frontend / UI Lead | Dashboard, courses, admin panel, auth pages, all components, theme, responsive design |
| **Roshan** | `context/roshan/` | To Be Assigned | Coordinate with team to determine area of ownership |

### Starting a Session

```bash
cd /home/soul/Desktop/pathora
opencode
```

**Utsav says:**
```
Read context/AGENTS.md. I'm Utsav (backend). Read context/utsav/my-scope.md and context/utsav/my-progress.md. Tell me what's next.
```

**Reejan says:**
```
Read context/AGENTS.md. I'm Reejan (frontend). Read context/reejan/my-scope.md and context/reejan/my-progress.md. Tell me what's next.
```

**Roshan says:**
```
Read context/AGENTS.md. I'm Roshan. Read context/roshan/my-scope.md and context/roshan/my-progress.md. Tell me what's next.
```

### During a Session

- Work only in your scope (see `my-scope.md`)
- If you need something from the other person, add it to `my-notes.md`
- When you finish a feature, update `my-progress.md`

### Ending a Session

1. Update your `context/[your-name]/my-progress.md`
2. Add handoff notes to `context/[your-name]/my-notes.md`
3. Run the merge script to update the main tracker:
   ```bash
   bash scripts/merge-context.sh
   ```
4. Commit your changes

### Merging Progress

After either person finishes work, run:
```bash
bash scripts/merge-context.sh
```

This pulls completed items from both `utsav/my-progress.md` and `reejan/my-progress.md` into the main `context/progress-tracker.md`.

### Communication Protocol

- **Need an API endpoint?** → Add to `context/reejan/my-notes.md`
- **Need a component/UI?** → Add to `context/utsav/my-notes.md`
- **Blocking issue?** → Add to your `my-progress.md` under "My Blockers"
- **Architecture change?** → Update `context/architecture-context.md` and notify the other person
