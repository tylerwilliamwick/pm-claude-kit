Use when you forward a bug, escalation, feature request, or any inbound that needs a priority call. Trigger on "triage this", "how urgent is this", "should we prioritize this", or when any incoming request, customer report, or Slack escalation needs quick scoring and a recommended action.

Use this when you forward a bug report, customer escalation, feature request, or any inbound that needs a quick priority call.

## Your task

### Step 1: Gather context (automatic)
**Pre-computed intelligence (check first):**
- `~/overnight-tasks/output/customer-signals/`: latest customer signal analysis (check if this issue is part of a known pattern)
- `~/overnight-tasks/output/sprint-health/`: latest sprint health snapshot (understand current capacity before recommending sprint insertion)

Before triaging, silently check:
- your Jira board (use Atlassian MCP jira_search): current sprint capacity and commitments
- your Jira epics (use Atlassian MCP jira_search): active initiatives and their health
- recent Jira activity (use Atlassian MCP jira_search): similar recent tickets
- your Confluence escalation queue (use Atlassian MCP confluence_search): existing escalation queue
- your recent OneNote notes: notes on current priorities
- **Slack archive search:** Search Slack for [key terms from the request]
  Look for: prior reports of the same issue, workarounds already shared, stakeholder opinions, customer mentions.
- **Sentry production data:** If the item is a production error or bug report, query Sentry via `/seer` for: affected user count, error frequency, error trend (increasing/stable/decreasing), first seen and last seen timestamps, related stack traces, and affected services. Use this data to ground the Impact and Urgency scores in real production telemetry instead of estimates.
- **Atlassian fallback:** If Atlassian MCP is available, search Jira for duplicates. If MCP fails (401/403), use local data.

### Step 2: Assess dimensions
Score each 1-5:
- **Impact:** How many users/agencies are affected? How severely? (1=cosmetic for few, 5=data loss/security for many)
- **Urgency:** Is there a deadline, SLA, or escalation path active? (1=no deadline, 5=SLA breach imminent)
- **Effort:** How much work to fix/deliver? (1=hours, 5=multiple sprints)
- **Risk of inaction:** What happens if we do nothing for 2 weeks? (1=nothing, 5=customer churn/compliance violation)
- **Dependencies:** Does this block or get blocked by other work? (1=standalone, 5=critical path blocker)

**Weighted priority score:** (Impact × 3 + Urgency × 3 + Risk_of_Inaction × 2 - Effort × 1) / 9
This weights customer impact and urgency highest, penalizes high effort slightly. Score range: ~0.3 to 5.0.

### Step 3: Classify
Based on scores, recommend one:
- **🔴 Drop everything** (score ≥4.0). Critical blocker, revenue/compliance/security risk. Pull into current sprint.
- **🟠 Next sprint** (score 3.0-3.9). High priority, should be planned for the next sprint boundary.
- **🟡 Backlog (prioritized)** (score 2.0-2.9). Important but not urgent. Slot into backlog with a target PI.
- **⚪ Backlog (unprioritized)** (score <2.0). Nice-to-have. Park it. Revisit quarterly.
- **🚫 Decline/Redirect**. Out of scope, wrong team, or not worth doing. Draft the "no" response.

### Step 4: Check for duplicates and patterns
Search Jira (local data or MCP) for:
- Similar titles or descriptions
- Same customer/agency reporting similar issues
- Related epics that might already cover this
- **Multi-angle duplicate detection:** Use the Atlassian `triage-issue` skill for duplicate search. It runs multiple JQL queries (by error message, by component, by reporter, by affected customer) to catch duplicates that a single keyword search would miss.
- **Regression check:** Search for previously fixed tickets with similar symptoms. If this was fixed before and recurred, flag it as a regression with the original fix ticket linked.
- **Pattern detection:** Is this the 3rd+ report of a similar issue? If so, flag it as a systemic problem, not an isolated bug.

### Step 5: Recommend action
Based on classification:
- Draft a Jira ticket description (if it should be created)
- Draft a reply to the requester (if it needs a response)
- Identify which epic/initiative this belongs under
- Flag if this changes priority of existing sprint work
- Suggest decomposition if the request is too large
- **If 🔴:** Also draft the sprint insertion justification. What gets bumped and why

### Step 6: Output
Present a triage card:

```
## Triage: [Title]
**Priority:** 🔴/🟠/🟡/⚪/🚫
**Score:** X.X / 5.0
**Impact:** X/5 | **Urgency:** X/5 | **Effort:** X/5 | **Risk:** X/5 | **Dependencies:** X/5
**Risk of inaction:** [specific description of what happens if we wait]
**Duplicates:** None / [ticket IDs]
**Pattern:** Isolated incident / Part of [pattern description]
**Salesforce:** [N cases for this customer/area, or "No SF data"]
**Recommendation:** [action]
**Affected initiative:** [epic/initiative name]
**If sprint insertion:** Displaces [what gets bumped], justify why this wins
```

## Self-Verification (run before presenting)
Before showing the triage card, verify:
- [ ] All 5 dimensions scored with rationale (not just numbers)
- [ ] Duplicate check was actually run against Jira data
- [ ] Recommendation is decisive. Not "maybe we should consider..."
- [ ] If 🔴, sprint impact is assessed (what gets bumped?)
- [ ] Risk of inaction describes a specific consequence, not just "things get worse"

## Rules
- Be decisive. The point of triage is a quick call, not analysis paralysis.
- If not enough context was given to triage, ask ONE targeted question.
- Always check for duplicates. Nothing wastes more time than duplicate tickets.
- If the request is clearly out of [YOUR_PROJECT] scope, say so and suggest the right team.
- After triaging, offer: "Want me to create this as a Jira ticket?" → `/jira`
- **Write to docs:** If the triage reveals a pattern or important decision, write to your docs/triage folder or Confluence via MCP.
- **Workflow links:** After triaging, also offer: `/risk-register` (if the issue reveals a systemic risk), `/dependency-map` (if it involves cross-team work), `/stakeholder-brief` (if stakeholders need to know), `/customer-signal` (if this is part of a customer pattern).
