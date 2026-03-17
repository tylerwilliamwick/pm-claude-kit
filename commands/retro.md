Use when you say "retro", "retrospective", "how did the sprint go", "weekly review", "what went well". Auto-detects timing context.

## Your task

Route to the right review format based on timing.

### Step 0: Fleet data gather (parallel)

Dispatch 4 background agents in parallel before analysis:

1. **sprint-data**: Pull Jira sprint completion, PRs merged, epics from active sprint data and open PRs
2. **team-sentiment**: Search Slack archive for "sprint OR blocker OR stuck OR great OR shipped"
3. **context-notes**: Read decisions log + recent notes + calendar meeting load
4. **overnight-outputs**: Read velocity-insight, scope-drift, customer-signals, backlog-prep output folders

Agents write summaries to /tmp/retro-fleet-{type}.md. Proceed to Step 1 once all agents return.

### Step 1: Detect timing context

1. Check what day it is
2. Check the sprint end date via Jira MCP

**Routing logic:**
- Friday or Monday → weekly review mode
- Within 2 days of sprint end date → sprint retro mode
- Otherwise → ask: "Sprint retro or weekly review?"

### Step 2: Execute the right review

#### Weekly review mode
Read ~/.claude/commands/weekly-review.md if it exists and follow its structure.

If not available:
1. Pull this week's Jira activity (completed, in progress, blocked)
2. Check GitHub PRs merged this week
3. Review action items completed vs. still open
4. Surface wins, misses, and carry-forward items
5. Draft a brief "This Week / Next Week" summary

#### Sprint retro mode
Read ~/.claude/commands/sprint-retro.md if it exists and follow its structure.

If not available:
1. Pull sprint metrics: planned vs. delivered, velocity, carry-over
2. Identify what went well (completed on time, unblocked quickly)
3. Identify what didn't (missed commitments, blockers, scope changes)
4. Surface patterns from the last 2-3 sprints if data is available
5. Draft retro notes: Went Well / Didn't Go Well / Action Items

### Step 3: Persist
- Save to your docs system or Confluence via MCP
- Offer: "/action-items to capture follow-ups"

$ARGUMENTS
