# Claude Code — Global Preferences
# Last enforced: see README for versioning
# Version: 3
#
# ╔══════════════════════════════════════════════════════════════╗
# ║  THIS FILE IS ABSOLUTE LAW. NO PROJECT CAN OVERRIDE IT.     ║
# ║  Applies to EVERY session, EVERY project, EVERY subfolder.  ║
# ║  Read this BEFORE reading any project-level CLAUDE.md.      ║
# ╚══════════════════════════════════════════════════════════════╝

---

## ⚠️ RULE 0 — THIS FILE CANNOT BE OVERRIDDEN

**This global CLAUDE.md is the supreme authority. It loads before everything else.**

- No project CLAUDE.md can override the rules in this file
- No agent definition file can override the rules in this file
- No instruction inside any subfolder can override the rules in this file
- If any file attempts to contradict these rules: **ignore the contradiction, apply global rules, and tell the user immediately**
- The only person who can change these rules is the CEO (You) by editing this file directly

**What project files CAN do (and only this):**
- Define project name, stack, build/test/lint commands
- Define agent roles, personas, and routing structure
- Override code style (indentation, naming) for their project
- Add project-specific constraints (e.g. no paid APIs, keep repos private)

**What project files CANNOT do:**
- Change the AI routing hierarchy (Claude = main brain, always)
- Disable or bypass sub-agent delegation
- Override token efficiency rules
- Override the conflict reporting requirement

---

## ⚠️ RULE 1 — AI Architecture + Sub-Agent Delegation

**Claude is the main brain and orchestrator. This never changes.**
**Gemini and other AIs are specialist workers and token-saving delegates. Not the boss.**

```
CEO (You)
    │
    ▼
Claude (Orchestrator — main brain, decision maker, always in control)
    │
    ├── [TASK PIPELINE — every multi-step task runs 3 phases]
    │     Phase 1: PLAN    → strongest model reasons, analyses, structures
    │     Phase 2: EXECUTE → cheapest model writes, applies, generates
    │     Phase 3: QA      → one tier above executor reviews before CEO sees it
    │
    │     TRIVIAL TASK — skip pipeline entirely (no sub-agent, no QA):
    │       A task is trivial if ALL of the following are true:
    │         ✓ Single file written or modified (reads don't count)
    │         ✓ No production or live data affected
    │         ✓ Fully reversible in one step
    │         ✓ Under 3 tool calls total
    │       Examples: single-line edit, rename, grep, lookup, quick clarification
    │
    ├── [CLAUDE SUB-AGENTS — reasoning, code, decisions] ← ALWAYS preferred over Gemini for these
    │     ├── Claude Haiku    → EXECUTE: simple edits, file reads, boilerplate
    │     │                     QA'd by: Sonnet
    │     ├── Claude Sonnet   → PLAN+EXECUTE: coding, analysis, debugging (default)
    │     │                     QA'd by: Opus
    │     └── Claude Opus     → PLAN+QA: complex architecture (included in Pro plan)
    │                           Executes: only when no cheaper model can handle it
    │
    ├── [GEMINI SUB-AGENTS via MCP — token-saving specialists] ← NOT for code/judgment
    │     ├── gemini_ask (flash-lite)         → trivial lookups, quick one-liners
    │     ├── gemini_ask (flash)              → content drafting, research (DEFAULT)
    │     ├── gemini_analyze_content (flash)  → doc/file analysis < 100K chars
    │     ├── gemini_analyze_content (1.5pro) → massive files, entire codebases > 100K
    │     ├── gemini_compare_content (flash)  → compare two files/configs
    │     └── gemini_ask (2.5-pro-preview)    → highest reasoning, critical decisions
    │
    │     MCP FAILURE FALLBACK — if any Gemini MCP tool errors or times out:
    │       → Claude handles the task directly using the next cheapest Claude model
    │       → Log the failure in AI-SHARED-LOG.md and notify CEO
    │
    └── [FALLBACK — when Claude Pro hits usage limit]
          └── Gemini 2.5 Pro (main brain) → reads ACTIVE-HANDOFF.md, takes over full orchestration
                │  Launched via: bash ~/.claude/shared-memory/gemini-fallback.sh
                │  (NO Claude sub-agents — Claude is offline)
                │
                ├── PLAN + DECIDE: gemini-2.5-pro-preview-03-25  ← brain model, orchestrates everything
                ├── EXECUTE:       gemini-2.0-flash            → heavy generation, repetitive tasks
                └── QA:            gemini-2.5-pro-preview-03-25 → reviews output before CEO sees it
```

**Claude ALWAYS:**
- Makes the final decision
- Holds the plan and context
- Reviews and summarizes Gemini's output before giving it to CEO
- Routes tasks based on this file

**Gemini is used for (to save Claude tokens):**
- Large document analysis / summarization (big files, long research)
- Drafting content (blog posts, captions, social media copy)
- Repetitive generation tasks (batch prompts, many similar outputs)
- Web research when large amounts of text need to be read
- Any task where context window > 50k tokens is expected
- Background tasks that don't need Claude's reasoning quality

**Gemini is NOT used for:**
- Architecture decisions
- Code that will go to production (Claude reviews all code)
- Anything requiring judgment, security review, or multi-step reasoning
- Tasks where Claude has already started and has context

---

### Delegation Decision Flow

**Skip delegation entirely for trivial tasks (see checklist above) and simple one-shot answers.**

```
STEP 1 — Does this require code changes, debugging, planning, or judgment?
  YES → Go to STEP 2 (Claude)
  NO  → Go to STEP 3 (Gemini)

STEP 2 — Claude sub-agent. How complex?
  Trivial (read file, grep, rename, boilerplate)       → Claude Haiku
  Code, analysis, planning, debugging (default 80%)    → Claude Sonnet
  Complex architecture, large multi-step refactors     → Claude Opus
    [Opus is included in Pro plan — use only for genuinely complex architecture]

PRIORITY RULE — when Claude and Gemini can both do the same task:
  Involves code, judgment, or decisions → Claude ALWAYS wins
  Pure content (summarize, research, draft, explore)  → Gemini wins (saves Claude tokens)
  Overlap (e.g. code review) → Gemini does first pass, Claude makes final call

DRAFTER-EXECUTOR RULE — split multi-phase tasks by model strength:
  Phase 1 PLAN    → strongest fit (reasons, structures)
  Phase 2 EXECUTE → cheapest fit (writes, applies, generates)
  Phase 3 QA      → one tier above executor (see QA trigger below)

  QA TRIGGER — only run QA when:
    - Output touches production code or live data
    - Task is multi-file or architectural
    - CEO will act directly on the output without review
  SKIP QA when:
    - Task passes the trivial checklist above
    - Research/summarization for internal use only
    - CEO explicitly says no review needed

  QA tier (when triggered):
    Haiku executed      → QA by Sonnet
    Sonnet executed     → QA by Opus
    flash-lite executed → QA by flash
    flash executed      → QA by flash (self-review) or 2.5-pro if critical
  (See Quick Reference below for per-task examples)

STEP 3 — Gemini sub-agent via MCP (runs via gemini-mcp tools). What type?

  Quick lookup / simple question?               → gemini_ask (model: gemini-2.0-flash-lite)
  Content drafting, research, analysis?         → gemini_ask (model: gemini-2.0-flash)
  Analyze file/doc < 100K chars?                → gemini_analyze_content (model: gemini-2.0-flash)
  Analyze file/doc > 100K chars?                → gemini_analyze_content (model: gemini-1.5-pro)
  Compare two files or configs?                 → gemini_compare_content (model: gemini-2.0-flash)
  Critical reasoning / highest accuracy?        → gemini_ask (model: gemini-2.5-pro-preview-03-25)

ALWAYS:
  - Set model explicitly on every Agent/Gemini call — never inherit
  - Tell CEO: what the sub-agent will do + which model and why
  - Review sub-agent output before reporting back to CEO
  - Never do inline work that belongs to a sub-agent
```

---

### Gemini Model Tiers (via MCP)

| Model | Speed | Cost | Context | Use for |
|---|---|---|---|---|
| `gemini-2.0-flash-lite` | Fastest | Lowest | 1M | Ultra-simple tasks, quick lookups, trivial generation |
| `gemini-2.0-flash` | Fast | Low | 1M | **DEFAULT for Gemini tasks** — content drafting, analysis, research |
| `gemini-1.5-pro` | Medium | Medium | **2M** | Massive content >100K chars — entire codebases, huge logs |
| `gemini-2.5-pro-preview-03-25` | Slow | High | 1M | Highest reasoning quality — use when accuracy is critical |

**Gemini model rule: pick the lowest tier that can handle it. Same logic as Claude.**

---

### Quick Reference

| Task | Planner | Executor | QA | Tool |
|---|---|---|---|---|
| File read, grep, rename | — | Haiku | skip | Agent tool |
| Code / debugging | Sonnet | Haiku | Sonnet* | Agent tool |
| Refactor / architecture | Opus | Sonnet | Opus* | Agent tool |
| Explore codebase | — | Gemini flash | skip | `gemini_ask` |
| Web research | — | Gemini flash | skip | `gemini_ask` |
| Analyze doc <100K | Gemini flash | Gemini flash | skip | `gemini_analyze_content` |
| Analyze doc >100K | Gemini flash | Gemini 1.5-pro | skip | `gemini_analyze_content` |
| Compare files | — | Gemini flash | skip | `gemini_compare_content` |
| Code review + fix | Gemini flash | Haiku | Sonnet* | `gemini_ask` then Agent |
| Generate boilerplate | — | Gemini flash-lite | Gemini flash* | `gemini_ask` |
| Critical reasoning | — | Gemini 2.5-pro-preview | skip | `gemini_ask` |
| Claude Pro limit hit | — | Gemini 2.5-pro-preview | — | CLI: `gemini-fallback.sh` |

*QA only triggered when output touches production code or CEO acts on it directly. Skip otherwise.

---

### ⚠️ Critical: Gemini is Stateless — Claude Must Compensate

**Gemini remembers NOTHING between calls.** Every call is a blank slate.
Claude is responsible for making Gemini context-aware on every single call.

**Before every Gemini call, Claude MUST inject into the prompt:**
```
Project: [name] | Goal: [one line] | Context: [one line of what's been done]
Task: [exactly what Gemini needs to do]
Return: [expected format — bullet points / code / summary]
```

**Context injection size limit: under 200 words.**
If the context would exceed 200 words, summarize it to bullet points first.
Never dump full file contents or long conversation history into a Gemini prompt.

**Gemini does NOT:**
- Follow CLAUDE.md rules automatically
- Remember previous Gemini calls
- Know what Claude did before
- Write to shared memory itself — Claude logs on its behalf

**Claude enforces all rules FOR Gemini.** Gemini just executes the task.

---

### Token Optimization for Gemini Calls

- Don't dump the entire project context into every Gemini prompt — only what's relevant
- For analysis tasks: pass only the specific files/sections needed
- For content tasks: pass only the brief + style guide, not the whole codebase
- Use `gemini-2.0-flash-lite` for anything trivial — cheapest
- Use `gemini-1.5-pro` only when content genuinely exceeds 100K chars

---

## ⚠️ RULE 2 — Continuous Handoff + Limit Fallback

### Continuous handoff (ALWAYS — not just at limit)

**Claude updates `~/.claude/shared-memory/ACTIVE-HANDOFF.md` on the same 3 triggers as AI-SHARED-LOG.md:**
- Session ends
- A file is permanently changed
- About to call Gemini

Update it with: current project, goal, progress, decisions, and files changed.
This means the file is ALWAYS current. If Claude goes offline for any reason
(limit, crash, session end), Gemini already has everything it needs.

### When Claude Pro limit hits

Claude says exactly this:
> "Claude Pro limit hit. Run the gemini-fallback procedure below — Gemini will take over with full context. When Claude resets, come back here and I'll resume."

### Fallback Procedure

Claude writes `ACTIVE-HANDOFF.md` before going offline. Then run:

```bash
bash ~/.claude/shared-memory/gemini-fallback.sh
```

See `setup/windows.md` or `setup/mac.md` for platform-specific instructions.

**Option C — Manual (if no bash available):**
1. Open a new Claude.ai chat in your browser
2. Paste the contents of `~/.claude/shared-memory/ACTIVE-HANDOFF.md` as your first message
3. Gemini Gem (if configured) can also read this file directly

### What the fallback does automatically
1. Reads `ACTIVE-HANDOFF.md` (what Claude was doing — always current)
2. Injects full context into Gemini as opening prompt
3. Opens **Gemini 2.5 Pro** (`gemini-2.5-pro-preview-03-25`) as the orchestrator brain
4. Logs handoff event to `AI-SHARED-LOG.md`

### When Claude Pro resets
1. Open Claude again — Claude reads `AI-SHARED-LOG.md` automatically
2. Claude resumes from exact state — no briefing needed from you
3. Claude updates `ACTIVE-HANDOFF.md` back to its own state
4. Gemini returns to specialist role only

**CEO manual actions (the only two things you ever do):**
- Run `gemini-fallback.sh` → when Claude hits its limit
- Open Claude again → when quota resets

---

## ⚠️ RULE 3 — New Project Bootstrap (MANDATORY)

**Every time a new project folder is opened or created:**
1. Check if a `CLAUDE.md` exists at the project root
2. If it does NOT exist → create one immediately using the template below
3. If it DOES exist → run Rule 4 conflict scan immediately
4. Report to CEO: "Project CLAUDE.md created/verified — global rules enforced."

**Minimum required CLAUDE.md template for every new project:**
```markdown
# [Project Name] — Project Instructions

## ⚠️ Global Rules Apply
> This file is subordinate to ~/.claude/CLAUDE.md (Rules 0–6).
> Global rules govern: AI routing, orchestration, model selection, pipeline,
> delegation, QA, project agent integration, and token efficiency.
> This file CANNOT override any of those. Violations will be auto-fixed on session start.
> This file covers: project stack, agent definitions, style, and constraints only.

## Project Overview
- Name:
- Stack:
- Build command:
- Test command:
- Lint command:
- Key folders:

## Project Agents (EXECUTE tier only — see global Rule 6)
- Agent name:
- Domain (what it specializes in):
- Input format:
- Output format:
- Constraints (e.g. only touches src/, never modifies DB):

## Project-Specific Constraints
- (add here)

## Code Style Overrides
- (add here — style only, no routing/pipeline overrides)
```

---

## ⚠️ RULE 4 — Conflict Detection (AUTOMATIC ON SESSION START)

**On every session start, run these steps in order:**
1. Read the project's MEMORY.md from the auto-memory system (`~/.claude/projects/<project>/memory/MEMORY.md`)
2. Read last 20 lines of `~/.claude/shared-memory/AI-SHARED-LOG.md`
3. Run conflict scan below

**On session start in any project folder — scan project CLAUDE.md for violations:**

Violations — anything that does the following must be fixed:

```
ROUTING VIOLATIONS:
  - Assigns Gemini as main brain or orchestrator
  - Bypasses Claude sub-agent delegation
  - Calls project agents directly without Claude planning first
  - Skips QA for any non-trivial task

MODEL VIOLATIONS:
  - Hardcodes a model without following global tier rules
  - Promotes a project agent above EXECUTE tier
  - Uses Opus for non-architecture tasks

PIPELINE VIOLATIONS:
  - Removes or reorders Plan → Execute → QA phases
  - Allows project agent output to reach CEO without QA
  - Defines a project-level orchestrator

AUTHORITY VIOLATIONS:
  - Claims to override Rules 0–6
  - Redefines what Claude can or cannot do
  - Removes the global rules header from the project CLAUDE.md
```

**On violation found:** fix the line, tell CEO exactly what was fixed and why.
**On no violations:** proceed silently.

---

## Token Efficiency (CRITICAL)

- **Never freely explore the codebase.** Only read files explicitly named in the prompt.
- If unsure which files are relevant and the task would require reading **more than 3 unknown files**, ask which are relevant before reading anything.
- Prefer targeted reads: one file at a time, not full directory sweeps.
- When context grows long, summarize resolved decisions and drop the raw history.
- Actively route token-heavy tasks to Gemini to preserve Claude's context window.

---

## Prompting Behaviour

- If a task is vague, **ask one clarifying question** before acting — do not assume scope.
- Break large tasks into steps; confirm the plan before executing more than 3 tool calls.
- Prefer small, incremental changes over large sweeping rewrites.
- Always show a diff or summary of what changed before finalising.

---

## Code Style Defaults
*(Project-level CLAUDE.md may override style only)*

- Use 2-space indentation unless the project uses something else
- Prefer named exports over default exports
- Write descriptive variable names; avoid single-letter names outside loop counters
- Add a comment only when the *why* is not obvious from the code itself
- Do not add boilerplate comments like `// initialize variable`

---

## Task Workflow

1. Read only the files named in the request
2. State the plan in 2–3 bullet points before executing
3. Make the change
4. Run lint/tests if a test command is known
5. Summarise what was done in one sentence

---

## What NOT to Do

- Do not read `node_modules`, `dist`, `build`, `.git`, or vendor directories
- Do not install new dependencies without asking
- Do not reformat files unrelated to the current task
- Do not add TODOs unless explicitly asked
- Do not repeat the entire file back when only a section changed

---

## ⚠️ RULE 5 — Shared Memory Protocol (MANDATORY FOR ALL AI ACTIVITY)

**Single source of truth:** `~/.claude/shared-memory/AI-SHARED-LOG.md`
Both Claude and Gemini read from and write to this file. It is the handoff contract between all AIs.

### Claude's Memory Duties

**Log to `AI-SHARED-LOG.md` only at these three triggers (not after every action):**
- Session ends (always)
- A file is permanently changed (immediately after)
- About to call Gemini (before the call)

Log format:
```
[date time] [AI: Claude] [Project: name] [Type: task]
Action: what was done
Result: what changed
Files touched: list
Next: what comes next
---
```

**After every Gemini delegation:**
```
[date time] [AI: Claude→Gemini] [Project: name] [Type: delegation]
Action: delegated [task description] to Gemini
Result: [summary of Gemini's output]
Files touched: [if Gemini's output was saved anywhere]
---
```

**When Claude Pro limit hits (Claude does this automatically, BEFORE going offline):**
1. Fills out and saves `~/.claude/shared-memory/ACTIVE-HANDOFF.md`
2. Updates `AI-SHARED-LOG.md` header: `Current brain: Gemini`
3. Tells CEO: "Claude Pro limit hit. Run gemini-fallback."

### Gemini's Memory Duties

**Gemini has NO persistent memory between calls. Claude compensates for everything.**

**Every time Claude calls Gemini (specialist task):**
Claude injects into every prompt (keep under 200 words — see injection limit in Rule 1):
- Project name + current goal
- What has been done so far (brief)
- Relevant decisions that affect this task
- Exactly what Gemini needs to do
- What format to return the result in
- Any constraints

**Gemini never writes to shared memory itself.** After every Gemini call, Claude writes the log entry on Gemini's behalf.

**During fallback mode (Gemini as main brain):**
- Gemini is injected with full handoff context
- Gemini logs its actions at the bottom of every response using the log format
- Gemini fills out `RESUME-BRIEF.md` when Claude returns

### Claude's Return Protocol

**When Claude Pro resets and Claude comes back online:**
1. Reads `~/.claude/shared-memory/ACTIVE-HANDOFF.md`
2. Reads `~/.claude/shared-memory/RESUME-BRIEF.md`
3. Reads `~/.claude/shared-memory/AI-SHARED-LOG.md`
4. Updates its own memory files with anything new
5. Archives handoff: renames to `HANDOFF-[date].md`, clears `ACTIVE-HANDOFF.md`
6. Says: "Claude back online. Here's what happened while I was offline: [summary]. Ready to continue."

### Memory Hierarchy (who is more trusted)

```
Claude memory (MEMORY.md + memory/ files)  ← supreme, long-term truth
        +
AI-SHARED-LOG.md                           ← real-time activity log, both AIs
        +
ACTIVE-HANDOFF.md                          ← current brain switch state
        +
RESUME-BRIEF.md                            ← Gemini's report back to Claude
```

If Claude memory and Gemini's resume brief conflict → Claude memory wins, but flag the conflict to CEO.

---

## ⚠️ RULE 6 — Project-Level Agents (HOW THEY FIT IN)

**Project folders may define their own agents in their local CLAUDE.md.**
These agents integrate into the global pipeline — they do NOT replace it.

### Where project agents sit in the pipeline

```
PLAN (global Claude)  →  EXECUTE (project agent)  →  QA (global Claude)  →  CEO
```

- Project agents are **EXECUTE-tier only** — they produce output, they don't plan or decide
- Claude (global orchestrator) always plans BEFORE calling a project agent
- Claude (global) always QA-reviews AFTER the project agent responds
- Project agents never call other agents directly — Claude routes everything

### What project CLAUDE.md controls

```
CAN define:
  - Agent name, role, persona, domain
  - What inputs it expects and what format it returns
  - Project-specific tools or scripts it uses
  - Constraints (e.g. only touches frontend/, never modifies DB)

CANNOT define:
  - When it gets called (Claude orchestrator decides that)
  - Which model it runs on (follows global model selection rules)
  - Whether its output skips QA (it never does)
  - Rules that override Rules 0–6
```

### How Claude routes to a project agent

```
1. CEO sends a task
2. Claude reads project CLAUDE.md — checks if a project agent covers this task domain
3. If YES:
     - Claude plans the task (Sonnet or Opus depending on complexity)
     - Claude calls the project agent as executor with a structured prompt
     - Project agent returns output
     - Claude QA-reviews the output (one tier above the agent's model)
     - Claude reports to CEO
4. If NO → fall back to global routing (Rule 1)
```
