# macOS Setup Guide

## Prerequisites

- [Claude Code CLI](https://claude.ai/code) installed
- [Gemini API key](https://aistudio.google.com/apikey) (free tier works)
- Terminal (built-in) or iTerm2

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
cp CLAUDE.md ~/.claude/CLAUDE.md
```

---

## Step 3 — Create the shared memory directory

```bash
mkdir -p ~/.claude/shared-memory
```

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

1. Open or create your Claude Code settings file at:
   ```
   ~/.claude/settings.json
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

## Step 6 — Optional: add Gemini API key to your shell profile

To avoid hardcoding the key in the config file:

```bash
# Add to ~/.zshrc or ~/.bash_profile
export GEMINI_API_KEY="your-api-key-here"
```

Then reference it in your MCP config:
```json
"GEMINI_API_KEY": "${GEMINI_API_KEY}"
```

---

## Step 7 — Run the fallback script (when needed)

When Claude Pro hits its usage limit:

```bash
bash ~/.claude/shared-memory/gemini-fallback.sh
```

---

## Directory Structure (after setup)

```
~/.claude/
├── CLAUDE.md                          ← global rules (this file)
├── shared-memory/
│   ├── AI-SHARED-LOG.md               ← activity log (both AIs write here)
│   ├── ACTIVE-HANDOFF.md              ← current handoff state
│   ├── RESUME-BRIEF.md                ← Gemini's report back to Claude
│   └── gemini-fallback.sh             ← fallback launcher
└── projects/
    └── <project-folder>/
        └── memory/                    ← auto-memory per project
```

---

## Troubleshooting

**`gemini-fallback.sh` fails to run**
- Verify execute permission: `chmod +x ~/.claude/shared-memory/gemini-fallback.sh`
- Make sure `bash` is available: `which bash`

**Gemini MCP tools not available in Claude Code**
- Verify your MCP config JSON is valid (use `python3 -m json.tool ~/.claude/claude_desktop_config.json`)
- Restart Claude Code after any config changes
- Verify your API key: `echo $GEMINI_API_KEY`

**`npx` not found**
- Install Node.js: `brew install node`
- Or use `node --version` to confirm it's installed
