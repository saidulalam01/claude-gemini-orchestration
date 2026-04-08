# Windows Setup Guide

## Prerequisites

- [Claude Code CLI](https://claude.ai/code) installed
- [Gemini API key](https://aistudio.google.com/apikey) (free tier works)
- Git Bash or WSL (for running the fallback script)

---

## Step 1 — Install Claude Code

Follow the official Claude Code installation guide. Once installed, verify with:

```bash
claude --version
```

---

## Step 2 — Set up your global CLAUDE.md

Copy `CLAUDE.md` from this repo to your Claude config directory:

```bash
# Git Bash or WSL
cp CLAUDE.md ~/.claude/CLAUDE.md
```

Or manually copy the file to:

```
C:\Users\<YourUsername>\.claude\CLAUDE.md
```

---

## Step 3 — Create the shared memory directory

```bash
mkdir -p ~/.claude/shared-memory
```

This creates `C:\Users\<YourUsername>\.claude\shared-memory\`.

Create the required files:

```bash
touch ~/.claude/shared-memory/AI-SHARED-LOG.md
touch ~/.claude/shared-memory/ACTIVE-HANDOFF.md
touch ~/.claude/shared-memory/RESUME-BRIEF.md
```

---

## Step 4 — Install the Gemini fallback script

```bash
cp setup/gemini-fallback.sh ~/.claude/shared-memory/gemini-fallback.sh
chmod +x ~/.claude/shared-memory/gemini-fallback.sh
```

---

## Step 5 — Configure Gemini MCP in Claude Code

Claude Code supports MCP (Model Context Protocol) servers. To connect Gemini:

1. Open or create your Claude Code settings file at:
   ```
   C:\Users\<YourUsername>\.claude\settings.json
   ```

2. Add a `mcpServers` block with your Gemini MCP server. Example:
   ```json
   {
     "mcpServers": {
       "gemini-mcp": {
         "command": "npx",
         "args": ["-y", "gemini-mcp"],
         "env": {
           "GEMINI_API_KEY": "your-api-key-here"
         }
       }
     }
   }
   ```

3. Restart Claude Code to load the MCP server. Verify the tools are available by typing `/mcp` in Claude Code.

> **Note:** `claude_desktop_config.json` is for the Claude Desktop app — it is NOT the same as Claude Code CLI. Claude Code reads from `~/.claude/settings.json`. Check the [Claude Code docs](https://docs.anthropic.com/en/docs/claude-code/mcp) for the latest MCP setup instructions.

---

## Step 6 — Run the fallback script (when needed)

When Claude Pro hits its usage limit:

**Option A — Git Bash:**
```bash
bash ~/.claude/shared-memory/gemini-fallback.sh
```

**Option B — WSL:**
```bash
bash /mnt/c/Users/<YourUsername>/.claude/shared-memory/gemini-fallback.sh
```

---

## Directory Structure (after setup)

```
C:\Users\<YourUsername>\.claude\
├── CLAUDE.md                          ← global rules (this file)
├── shared-memory\
│   ├── AI-SHARED-LOG.md               ← activity log (both AIs write here)
│   ├── ACTIVE-HANDOFF.md              ← current handoff state
│   ├── RESUME-BRIEF.md                ← Gemini's report back to Claude
│   └── gemini-fallback.sh             ← fallback launcher
└── projects\
    └── <project-folder>\
        └── memory\                    ← auto-memory per project
```

---

## Troubleshooting

**`gemini-fallback.sh` fails to run**
- Make sure you're using Git Bash or WSL, not Command Prompt or PowerShell
- Verify the script has execute permission: `chmod +x ~/.claude/shared-memory/gemini-fallback.sh`

**Gemini MCP tools not available in Claude Code**
- Verify your MCP config JSON is valid (no trailing commas)
- Restart Claude Code after any config changes
- Check that your Gemini API key is set correctly

**Claude can't find `~/.claude/`**
- On Windows, `~` resolves to `C:\Users\<YourUsername>\` in Git Bash
- In PowerShell, use `$env:USERPROFILE\.claude\` instead
