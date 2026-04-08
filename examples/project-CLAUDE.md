# My Project — Project Instructions

## ⚠️ Global Rules Apply
> This file is subordinate to ~/.claude/CLAUDE.md (Rules 0–6).
> Global rules govern: AI routing, orchestration, model selection, pipeline,
> delegation, QA, project agent integration, and token efficiency.
> This file CANNOT override any of those. Violations will be auto-fixed on session start.
> This file covers: project stack, agent definitions, style, and constraints only.
> (Rules 0–6 in global CLAUDE.md)

---

## Project Overview
- Name: my-project
- Stack: Next.js 14, TypeScript, Tailwind CSS, Supabase
- Build command: `npm run build`
- Test command: `npm test`
- Lint command: `npm run lint`
- Key folders:
  - `src/app/` — Next.js App Router pages
  - `src/components/` — shared UI components
  - `src/lib/` — utilities and helpers
  - `supabase/` — database migrations and config

---

## Project Agents (EXECUTE tier only — see global Rule 6)

### frontend-agent
- Domain: UI components, Tailwind styling, Next.js pages
- Input format: component name + requirements + figma reference (if any)
- Output format: TypeScript React component
- Constraints: only touches `src/components/` and `src/app/`; never modifies database or API routes

### api-agent
- Domain: Next.js API routes, Supabase queries, server actions
- Input format: endpoint description + expected input/output
- Output format: TypeScript route handler or server action
- Constraints: only touches `src/app/api/` and `src/lib/`; never modifies UI components

---

## Project-Specific Constraints
- Never use `any` type in TypeScript — use `unknown` and narrow it
- All database queries go through `src/lib/db.ts` — no direct Supabase calls in components
- Environment variables must be validated with Zod at startup (`src/lib/env.ts`)
- No new npm dependencies without explicit approval

---

## Code Style Overrides
- 2-space indentation (TypeScript/JSX)
- Prefer `const` over `let`; never use `var`
- Component files use PascalCase (`UserCard.tsx`)
- Utility files use kebab-case (`format-date.ts`)
- Use named exports only — no default exports
