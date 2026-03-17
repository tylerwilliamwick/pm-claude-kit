Use when you say "retro", "retrospective", "how did the sprint go", "weekly review", "what went well". Auto-detects timing context.

## Your task

Route to the right review format based on timing.

### Step 1: Gather data

Run these steps sequentially before analysis:

1. If Jira MCP is available, pull sprint data: completion rates, PRs merged, epics from the active sprint and open PRs
2. Review recent notes, decisions, and any context shared in the conversation
3. Run the retro format below

### Step 2: Detect timing context

1. Check what day it is
2. Check the sprint end date via Jira MCP if available

**Routing logic:**
- Friday or Monday → weekly review mode
- Within 2 days of sprint end date → sprint retro mode
- Otherwise → ask: "Sprint retro or weekly review?"

### Step 3: Execute the right review

#### Weekly review mode
1. Pull this week's Jira activity if available (completed, in progress, blocked)
2. Check GitHub PRs merged this week
3. Review action items completed vs. still open
4. Surface wins, misses, and carry-forward items
5. Draft a brief "This Week / Next Week" summary

#### Sprint retro mode
1. Pull sprint metrics if available: planned vs. delivered, carry-over
2. Identify what went well (completed on time, unblocked quickly)
3. Identify what didn't (missed commitments, blockers, scope changes)
4. Surface patterns from the last 2-3 sprints if data is available
5. Draft retro notes: Went Well / Didn't Go Well / Action Items

### Step 4: Persist
- Save to your docs system or Confluence via MCP if available; otherwise note findings in the conversation
- Offer: "/action-items to capture follow-ups"

$ARGUMENTS

**Next step:** Capture action items in your issue tracker or run /decision for any significant calls made during the retro.
