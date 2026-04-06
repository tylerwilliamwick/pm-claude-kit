# pm-claude-kit

Most AI coding assistants behave like generic helpers. This kit makes Claude Code behave like a peer PM: structured decisions, stakeholder-ready output, and guardrails that prevent the mistakes that erode trust with engineering and leadership.

A PM-specific Claude Code starter kit. It ships quality guardrails, a delivery pipeline, and PM-focused slash commands so Claude behaves like a peer product manager instead of a generic assistant.

---

## Quick Start

```bash
git clone https://github.com/YOUR_ORG/pm-claude-kit.git
cd pm-claude-kit
./install.sh
```

The installer prompts for five values (name, company, team, Jira project key, Confluence space key), substitutes them into `CLAUDE.md`, and copies all files into `~/.claude/`.

**Verify the install:**

1. Open a new Claude Code session. Your name should appear in the first response.
2. Run `/prd` and confirm it generates a structured PRD template.
3. Run `/jira-story` and confirm it produces a properly formatted story.
4. Check `~/.claude/rules/` contains `voice.md`, `workarounds.md`, and `anti-hallucination.md`.
5. Check `~/.claude/settings.json` contains the two hook entries under `PreToolUse`.

---

## Delivery Pipeline

Run these in sequence for any feature or initiative:

| Command | What it does |
|---------|-------------|
| `/plan-ceo-review` | Scope and vision gate. Validates the "why" before any work starts. |
| `/plan-eng-review` | Architecture and feasibility gate. Surfaces blockers before sprint planning. |
| `/build` | Implement, commit, push, open PR. Writes PM-legible commit messages. |
| `/code-review` | Structured review against the original plan. Flags scope drift. |
| `/ship` | Merge check, go/no-go confirmation, closes linked Jira ticket. |
| `/qa` | Three-tier test and fix loop. Stops when all tiers pass. |
| `/doc-update` | Updates Confluence page or inline docs to match what shipped. |
| `/retro` | Sprint or project retrospective. Outputs action items to Jira. |

Each command ends with a suggested next step.

---

## Command Reference

| Command | Trigger phrase | Output |
|---------|---------------|--------|
| `/prd` | "write a PRD", "draft a spec" | PRD .docx: problem, AC, open questions |
| `/jira-story` | "write a story", "create a ticket" | Jira-ready story with numbered AC |
| `/plan-ceo-review` | "CEO review", "vision gate" | Go/no-go with strategic rationale |
| `/plan-eng-review` | "eng review", "feasibility" | Technical risk list + open questions |
| `/build` | "build this", "implement" | Code commits + PR description |
| `/code-review` | "review this", "code review" | Structured review against plan |
| `/ship` | "ship it", "ready to merge" | Merge checklist + Jira close |
| `/qa` | "test this", "QA" | Test results + fix loop |
| `/doc-update` | "update the docs", "update Confluence" | Confluence page edit |
| `/retro` | "retro", "retrospective" | What went well / delta / actions |
| `/triage` | "triage this bug", "prioritize" | Impact, urgency, effort, dependencies |
| `/tell` | "draft a Slack message", "write an update" | Stakeholder comms draft |
| `/decision` | "log this decision", "ADR" | Decision record saved to vault |
| `/daily-brief` | "morning brief", "what's on my plate" | Sprint status + priority queue |

---

## Integrations

All integrations use MCP servers. Add them to `~/.claude/settings.json` under `mcpServers`. A ready-to-fill template is in `settings.json.template`.

| Integration | MCP server | Setup guide |
|------------|-----------|------------|
| Jira + Confluence | mcp-atlassian | https://github.com/sooperset/mcp-atlassian |
| GitHub | github-mcp-server | https://github.com/github/github-mcp-server |
| Figma | Figma-Context-MCP | https://github.com/GLips/Figma-Context-MCP |

Slack, Outlook, and OneNote use local workarounds (scripts + AppleScript) documented in `rules/workarounds.md`.

---

## Rules

Three rules files ship with the kit. Claude reads them at session start via `CLAUDE.md`.

| File | What it enforces |
|------|-----------------|
| `rules/voice.md` | No em dashes in deliverables. No AI clichés or corporate filler. Banned words and structural patterns listed with plain-English replacements. |
| `rules/workarounds.md` | Claude must attempt a workaround before saying something is impossible. Recipes for Slack, Outlook, Obsidian, Salesforce, Figma, and more. |
| `rules/anti-hallucination.md` | No fabricated identifiers, ticket numbers, or metrics. Source all data claims. Flag uncertainty explicitly. |

---

## Hooks

Two hooks install automatically and run on every Claude Code session.

**em-dash-guard** (`hooks/em-dash-guard.py`): Fires on every `Write` or `Edit` tool call. Blocks the write if the output contains em dashes, en dashes, or double hyphens used as sentence punctuation in a deliverable file type (.docx, .md, Jira/Confluence writes). Returns an error that Claude must resolve by restructuring the sentence.

**model-routing-enforcer** (`hooks/model-routing-enforcer.py`): Fires on every `Agent` spawn. Checks that the spawn includes an explicit `model` parameter. Blocks spawns that inherit the session model implicitly, which prevents accidental Opus usage on cheap tasks.

---

## Customizing After Install

The installer substitutes template variables once during setup. To change them later, edit `~/CLAUDE.md` directly and replace the values:

```
{{YOUR_NAME}}         ->  your name
{{YOUR_COMPANY}}      ->  your company
{{YOUR_TEAM}}         ->  your team name
{{JIRA_PROJECT}}      ->  Jira project key (e.g. PLATFORM)
{{CONFLUENCE_SPACE}}  ->  Confluence space key (e.g. PLAT)
```

To add a new slash command, create a `.md` file in `~/.claude/commands/` following the pattern of the existing commands. The filename becomes the command name (e.g. `my-command.md` -> `/my-command`).

To update a rules file, edit it directly in `~/.claude/rules/`. Changes take effect in the next Claude Code session.
