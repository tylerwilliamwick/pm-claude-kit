Use before any meeting, when you say "prep me for", "meeting prep", "what should I know for [meeting]", "I have a meeting with [person]", or "next meeting". Also use when a meeting is within 30 minutes and you haven't prepped yet.

**Argument:** $ARGUMENTS (meeting name, attendee, or topic. Or "next" for the next upcoming meeting)

## Your task

### Step 1: Identify the meeting
From the argument, find the meeting:
- If "next" → check your calendar and find the next meeting within 4 hours
- If a person's name → find the next meeting with that person
- If a topic → find the next meeting matching that topic
- If a specific meeting name → find that meeting

### Step 2: Gather context (automatic)
Once the meeting is identified, gather ALL relevant context:

**Pre-computed intelligence (check first):**
- `~/overnight-tasks/output/meeting-prep/`: overnight meeting prep briefs (may already have today's meeting covered)
- `~/overnight-tasks/output/stakeholder-pulse/`: latest stakeholder relationship health (context on attendee relationships)

**Always check:**
- Your calendar: meeting details, attendees, recurrence pattern
- Your calendar history: past meetings with same attendees/topic
- Your recent OneNote notes: notes from prior instances of this meeting
- Your Claude memory: prior context on the topic or attendees
- Your decisions log (check conversation context): decisions relevant to this meeting's topic
- Your docs folder: relevant notes, decision records, risk register

**If attendees are from specific teams, also check:**
- your Jira board (use Atlassian MCP jira_search): sprint status (for engineering syncs)
- your Jira epics (use Atlassian MCP jira_search): initiative health (for roadmap reviews)
- GitHub PR activity for engineering meetings (use GitHub MCP mcp__github__list_pull_requests)
- your Confluence space (use Atlassian MCP confluence_search): initiative docs
- search Slack for [attendee name OR topic]: recent discussions
- **Atlassian fallback:** If Atlassian MCP is available, pull fresh sprint/epic data for meeting topics. If MCP fails (401/403), use local data.

**If it's a customer meeting:**
- Adjust tone recommendations for external audience

**If it's a recurring meeting:**
- Check previous meeting notes for action items committed to
- Surface any open items from last instance

**Circleback meeting intelligence:**
- Query Circleback MCP tools for prior meetings with the same attendees or topic. Pull action items from the last instance of recurring meetings.
- Check for AI-extracted summaries and decisions from recent related meetings.
- If the meeting recurs, surface uncommitted action items from the previous instance.

**Cross-system knowledge search:**
- Use the Atlassian `search-company-knowledge` skill to search across Confluence and Jira for context related to the meeting topic. This catches relevant pages and tickets that local synced data might miss.

### Step 3: Build the prep brief

```markdown
# Meeting Prep: [Meeting Name]
**Date/Time:** [date and time]
**Attendees:** [names and roles]
**Duration:** [length]
**Recurrence:** [one-time / weekly / biweekly / etc.]

## Context
[2-3 sentences: why this meeting exists, what's the ongoing thread]

## Since Last Meeting
- [Key changes, decisions, or progress since the last instance]
- [Any action items committed to. Are they done? ✅/❌]

## What You Should Know Going In
- [Key data points, sprint numbers, initiative status]
- [Any surprises or changes that might come up]
- [Relevant decisions or escalations from other contexts]

## Talking Points
1. [Topic to raise, with supporting data]
2. [Topic to raise, with supporting data]
3. [Topic to raise, with supporting data]

## Anticipated Questions
- [Question someone might ask] → [Suggested response or data point]
- [Question someone might ask] → [Suggested response or data point]

## Decisions Needed
- [Any decisions this meeting should resolve, with recommended position]

## Open Items to Track
- [Action items to watch for during the meeting]
```

### Step 4: Route outputs
- Display in conversation (primary — needed immediately)
- If there's time, write to your docs/daily folder or Confluence via MCP

## Self-Verification (run before presenting)
Before showing the prep, verify:
- [ ] Prior action items are checked. Walking in having dropped a commitment is worse than no prep
- [ ] Talking points include supporting data, not just topics to raise
- [ ] Anticipated questions have prepared responses, not just "they might ask about X"
- [ ] Calendar history was checked for meeting frequency and prior discussions
- [ ] If customer meeting, customer account data was checked for active cases and opportunities

## Rules
- Speed is critical. Meeting prep is often requested when a meeting is imminent. Get it done fast.
- Be opinionated about talking points. Suggest what to raise, not just what could be raised.
- Surface open action items from prior meetings prominently. Walking in having completed your commitments is table stakes.
- If you can't find prior meeting context, say so and prep based on what's available.
- If the meeting is with a customer or external party, flag that and adjust tone recommendations accordingly.
- **Workflow links:** After prep, offer: `/stakeholder-brief` (prep a brief to share during the meeting), `/decision` (record decisions after the meeting), `/update` (draft follow-up communication), `/action-items from [meeting]` (capture commitments after the meeting).
