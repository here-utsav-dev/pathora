<!-- BEGIN:nextjs-agent-rules -->

# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` before writing any code. Heed deprecation notices.

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

## How To Resume Work

When starting a new session in this project:

1. Read this file (`AGENTS.md`) first.
2. Read all context files in order (steps 1-6 above).
3. Check `context/progress-tracker.md` for current state.
4. Ask the user what to work on, or proceed with the next pending item.

## How Your Coworker Uses This

Your coworker does the exact same thing:

```
cd /home/soul/Desktop/pathora
opencode
```

Then say: `"Read context/AGENTS.md and continue from where we left off"`

The context files are the shared source of truth. Both of you must update `progress-tracker.md` before ending a session.

## Team Workflow (Utsav + Reejan)

### Who Does What

| Person | Folder | Role | Owns |
|--------|--------|------|------|
| **Utsav** | `context/utsav/` | Backend / Architecture Lead | Auth, API routes, token ledger, fee engine, classifier, rate limiting, DB schema, deployment |
| **Reejan** | `context/reejan/` | Frontend / UI Lead | Dashboard, courses, admin panel, auth pages, all components, theme, responsive design |

### Starting a Session

**Utsav says:**
```
Read context/AGENTS.md. I'm Utsav (backend). Read context/utsav/my-scope.md and context/utsav/my-progress.md. Tell me what's next.
```

**Reejan says:**
```
Read context/AGENTS.md. I'm Reejan (frontend). Read context/reejan/my-scope.md and context/reejan/my-progress.md. Tell me what's next.
```

### Ending a Session

1. Update your `context/[your-name]/my-progress.md`
2. Add handoff notes to `context/[your-name]/my-notes.md`
3. Run: `bash scripts/merge-context.sh`
4. Commit changes

### Communication

- Need an API? → Add to `context/reejan/my-notes.md`
- Need a component? → Add to `context/utsav/my-notes.md`
- Blocking issue? → Add to your `my-progress.md` under "My Blockers"
