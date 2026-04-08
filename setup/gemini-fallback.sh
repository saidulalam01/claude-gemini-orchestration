#!/usr/bin/env bash
# gemini-fallback.sh
# Reads ACTIVE-HANDOFF.md and launches Gemini 2.5 Pro as the main brain
# when Claude Pro hits its usage limit.
#
# Usage:
#   bash ~/.claude/shared-memory/gemini-fallback.sh
#
# Works on: macOS, Linux, Windows (Git Bash or WSL)

set -e

SHARED_DIR="$HOME/.claude/shared-memory"
HANDOFF_FILE="$SHARED_DIR/ACTIVE-HANDOFF.md"
LOG_FILE="$SHARED_DIR/AI-SHARED-LOG.md"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# ── 1. Check handoff file exists ────────────────────────────────────────────
if [ ! -f "$HANDOFF_FILE" ]; then
  echo ""
  echo "ERROR: ACTIVE-HANDOFF.md not found at $HANDOFF_FILE"
  echo "Claude should have written this before going offline."
  echo "If it didn't, use Option C (manual) from the README."
  exit 1
fi

# ── 2. Read handoff content ──────────────────────────────────────────────────
HANDOFF_CONTENT=$(cat "$HANDOFF_FILE")

# ── 3. Log the handoff event ─────────────────────────────────────────────────
mkdir -p "$SHARED_DIR"
cat >> "$LOG_FILE" << EOF

[$DATE] [AI: Claude→Gemini] [Type: fallback]
Action: Claude Pro limit hit — Gemini taking over as main brain
Trigger: gemini-fallback.sh executed
Handoff file: $HANDOFF_FILE
---
EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude → Gemini Handoff"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Handoff logged. Copy the prompt below into Gemini 2.5 Pro."
echo "(gemini.google.com → select Gemini 2.5 Pro)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "GEMINI OPENING PROMPT:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
cat << PROMPT
You are taking over from Claude as the main AI brain. Claude has hit its usage limit.

Here is the full handoff context — read it carefully before doing anything:

---
$HANDOFF_CONTENT
---

Your role now:
- You are the orchestrator. Make decisions, plan tasks, execute work.
- Use gemini-2.0-flash for heavy generation tasks to save your own context.
- Log every significant action at the bottom of your response in this format:
    [date] [AI: Gemini] [Project: name] [Type: task]
    Action: what you did
    Result: what changed
    Files touched: list
    Next: what comes next
    ---
- When the user tells you Claude is back online, write a RESUME-BRIEF.md summary
  so Claude can pick up exactly where things stand.

What do you need from me to continue?
PROMPT

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Handoff complete. Paste the prompt above into Gemini 2.5 Pro."
echo "When Claude resets, open Claude Code again — it will resume automatically."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
