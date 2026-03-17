#!/usr/bin/env bash
set -euo pipefail

# pm-claude-kit installer
# Installs PM-specific Claude Code configuration: CLAUDE.md, rules, commands, hooks

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}pm-claude-kit installer${NC}"
echo "========================"
echo ""

# Check Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Error: Claude Code not found. Install it first: https://claude.ai/code${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Claude Code found: $(claude --version 2>/dev/null || echo 'installed')${NC}"
echo ""

# Prompt for configuration
echo "Let's configure your setup."
echo ""

read -p "Your name: " USER_NAME
read -p "Your company: " USER_COMPANY
read -p "Your team name (e.g. 'Platform Team'): " USER_TEAM
read -p "Jira project key (e.g. PLATFORM, CORE, ENG): " JIRA_PROJECT
read -p "Confluence space key (e.g. PLAT, ENG): " CONFLUENCE_SPACE

echo ""
echo -e "${YELLOW}About to install with:${NC}"
echo "  Name:       $USER_NAME"
echo "  Company:    $USER_COMPANY"
echo "  Team:       $USER_TEAM"
echo "  Jira:       $JIRA_PROJECT"
echo "  Confluence: $CONFLUENCE_SPACE"
echo ""
read -p "Proceed? [Y/n] " CONFIRM
CONFIRM="${CONFIRM:-Y}"
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Create directories
mkdir -p "$CLAUDE_DIR/rules" "$CLAUDE_DIR/commands" "$CLAUDE_DIR/hooks"

# Install CLAUDE.md (with variable substitution)
echo ""
echo "Installing CLAUDE.md..."
sed \
    -e "s/{{YOUR_NAME}}/$USER_NAME/g" \
    -e "s/{{YOUR_COMPANY}}/$USER_COMPANY/g" \
    -e "s/{{YOUR_TEAM}}/$USER_TEAM/g" \
    -e "s/{{JIRA_PROJECT}}/$JIRA_PROJECT/g" \
    -e "s/{{CONFLUENCE_SPACE}}/$CONFLUENCE_SPACE/g" \
    "$SCRIPT_DIR/CLAUDE.md" > "$HOME/CLAUDE.md"
echo -e "${GREEN}  ✓ ~/CLAUDE.md${NC}"

# Install rules (no merge needed, these are reference files)
echo "Installing rules..."
for f in "$SCRIPT_DIR/rules/"*.md; do
    [[ -e "$f" ]] || continue
    fname=$(basename "$f")
    cp "$f" "$CLAUDE_DIR/rules/$fname"
    echo -e "${GREEN}  ✓ rules/$fname${NC}"
done

# Install commands (merge: don't overwrite files that already exist with custom content)
echo "Installing commands..."
for f in "$SCRIPT_DIR/commands/"*.md; do
    [[ -e "$f" ]] || continue
    fname=$(basename "$f")
    dest="$CLAUDE_DIR/commands/$fname"
    if [[ -f "$dest" ]]; then
        echo -e "${YELLOW}  ~ commands/$fname (already exists, skipping)${NC}"
    else
        cp "$f" "$dest"
        echo -e "${GREEN}  ✓ commands/$fname${NC}"
    fi
done

# Install hooks
echo "Installing hooks..."
for f in "$SCRIPT_DIR/hooks/"*.py; do
    [[ -e "$f" ]] || continue
    fname=$(basename "$f")
    cp "$f" "$CLAUDE_DIR/hooks/$fname"
    echo -e "${GREEN}  ✓ hooks/$fname${NC}"
done

# Register hooks in settings.json
echo "Registering hooks in settings.json..."
SETTINGS="$CLAUDE_DIR/settings.json"

if [[ ! -f "$SETTINGS" ]]; then
    echo '{}' > "$SETTINGS"
fi

# Use Python to safely merge hooks into settings.json
python3 - <<EOF
import json, sys, os

settings_path = "$SETTINGS"
with open(settings_path) as f:
    settings = json.load(f)

new_hooks = [
    {
        "matcher": "Write|Edit",
        "hooks": [{"type": "command", "command": "python3 $HOME/.claude/hooks/em-dash-guard.py"}]
    },
    {
        "matcher": "Agent",
        "hooks": [{"type": "command", "command": "python3 $HOME/.claude/hooks/model-routing-enforcer.py"}]
    }
]

if "hooks" not in settings:
    settings["hooks"] = {}
if "PreToolUse" not in settings["hooks"]:
    settings["hooks"]["PreToolUse"] = []

# Check for duplicates before adding
existing_commands = {
    h.get("command", "")
    for entry in settings["hooks"]["PreToolUse"]
    for h in entry.get("hooks", [])
}

for hook_entry in new_hooks:
    for h in hook_entry.get("hooks", []):
        if h["command"] not in existing_commands:
            settings["hooks"]["PreToolUse"].append(hook_entry)
            break

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)

print("  hooks registered")
EOF

echo -e "${GREEN}  ✓ Hooks registered in settings.json${NC}"

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Next steps:"
echo ""
echo "  1. Set up MCP servers for full integration:"
echo "     - Atlassian (Jira + Confluence): https://github.com/sooperset/mcp-atlassian"
echo "     - GitHub: https://github.com/github/github-mcp-server"
echo "     - Figma: https://github.com/GLips/Figma-Context-MCP"
echo "     Add them to ~/.claude/settings.json under 'mcpServers'"
echo ""
echo "  2. Open a new Claude Code session and verify your name appears in the first response"
echo ""
echo "  3. Try /prd to test the PRD template"
echo ""
echo "  4. See README.md for the full command reference"
echo ""
