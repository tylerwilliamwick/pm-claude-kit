Use when you need a status update, stakeholder alignment doc, or progress report. Trigger on "draft an update", "status update", "write an update for [audience]", "update leadership on", or when sprint, initiative, or project status needs to be communicated to a specific audience.

## Arguments
$ARGUMENTS: required: topic and audience (e.g., "containerization status for leadership", "sprint update for engineering")

## Your task

### Step 1: Identify parameters
From the input, determine:
- **Topic:** What the update covers
- **Audience:** Who receives it (defaults to leadership if not specified)
- **Medium:** Email, Confluence page, slide, Slack post (defaults to email)
- **Scope:** Point-in-time snapshot vs. period summary (e.g., "this sprint" vs. "since last PI")

### Step 2: Gather current state (automatic)
**Pre-computed intelligence (check first):**
- `~/overnight-tasks/output/sprint-health/`: sprint health numbers (cite directly)
- `~/overnight-tasks/output/scope-drift/`: scope changes since commitment
- `~/overnight-tasks/output/stakeholder-pulse/`: relationship context for audience

**Live data:**
- your Jira board (use Atlassian MCP jira_search): sprint progress and velocity
- your Jira epics (use Atlassian MCP jira_search): initiative health
- recent Jira activity (use Atlassian MCP jira_search): recent ticket activity
- your recent OneNote notes: recent weekly notes for decisions and commitments
- your Confluence space (use Atlassian MCP confluence_search): relevant initiative pages
- GitHub PR activity (use GitHub MCP mcp__github__list_pull_requests for technical delivery activity)
- search Slack for [update topic keywords]: recent discussion context and activity
- your decisions log (check conversation context): recent decisions to surface
- **Atlassian fallback:** If Atlassian MCP is available, try fetching live Jira/Confluence data for the freshest numbers. If MCP fails (401/403), use the local synced data and note the limitation.

**Cross-reference for accuracy:**
- Do Jira numbers match what was said in recent meetings? Flag discrepancies.
- Are there risks in the risk register that this update should acknowledge?
- Have any decisions been made since the last update that change the narrative?

### Step 3: Tailor to audience
Before drafting, identify who the audience is from the input. Then tailor accordingly:

**For leadership/executive audiences:**
- Lead with outcomes and customer impact
- Surface key risks and decisions needed. With options and recommendation
- Keep it scannable. Use bullets and clear headers
- Minimize technical detail unless it's decision-relevant
- Include confidence level for delivery dates

**For engineering/technical audiences:**
- Lead with technical context and constraints
- Connect implementation work to product rationale
- Be precise about scope, dependencies, and what's in/out
- Reference specific tickets and PRs

**For customer-facing or CS/support audiences:**
- Plain language only. No internal jargon
- Focus on what changed, why it matters, and what action (if any) is needed
- Assume a non-technical government agency admin as the reader
- Include customer-ready language they can forward

### Step 4: Structure the update
```markdown
## Status / Where We Are
[Quantified progress: "7/12 stories complete (58%)", not "making good progress"]

## What Shipped / What Changed
[Concrete deliverables with dates]

## What's Next
[Upcoming milestones with dates and owners]

## Key Decisions or Tradeoffs
[Decisions made since last update, with rationale]

## Risks and Open Items
[Active risks with likelihood/impact, mitigations in progress]

## What We Need (if any action required)
[Specific asks with deadlines: "Need [person] to approve [X] by [date]"]
```

Omit any section that has nothing meaningful to say.

### Step 5: Quantify everything
Replace vague language with real numbers:
- ❌ "Making good progress" → ✅ "7/12 stories complete (58%), on track for 3/20 target"
- ❌ "Some risks remain" → ✅ "2 medium risks: ArcGIS dependency (ETA unknown) and QA capacity (1 tester for 8 stories)"
- ❌ "Team is working on it" → ✅ "3 PRs merged this week, 2 in review, 1 blocked on API spec"

### Step 6: Route outputs
- Save as .docx using python-docx. Also display in conversation.
- Write to your docs/updates folder or Confluence via MCP
- **Optional Confluence publish:** Offer "Publish this update to Confluence?" If accepted, use Atlassian MCP to create or update the page in the appropriate Confluence space.

## Self-Verification (run before presenting)
Before showing the update, verify:
- [ ] Every claim is backed by a number or specific reference. No vague qualitative language
- [ ] Audience is identified and tone is matched (leadership ≠ engineering ≠ customer)
- [ ] Risks section includes specific likelihood/impact, not just "there are risks"
- [ ] "What We Need" is actionable. Names a person, an ask, and a deadline
- [ ] No contradictions between this update and recent decisions in the decisions log
- [ ] Sections with nothing to say are omitted, not padded with filler

## Rules
- If the audience isn't clear from the input, ask before drafting.
- Do not pad. If a section has nothing meaningful to say, omit it.
- Distinguish clearly between what is decided vs. what is still open.
- Prefer concrete numbers over qualitative assessments.
- **Workflow links:** After drafting, offer: `/pressure-test` (stress-test the update before sending), `/stakeholder-brief` (generate a shorter version for a different audience), `/decision` (record any decisions embedded in the update).
