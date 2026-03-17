Use when you say "we decided", "let's go with", "the call is", "I'm going to go with", "final call", "going with option", or describe choosing between options. Also use after any meeting where a direction was set, or when a prior decision needs to be reversed or revisited.

Use this when you say "we decided," "let's go with," "the call is," or describe choosing between options.

## Your task

### Step 1: Extract the decision
From the input, identify:
- What was decided
- What alternatives were considered (or ask if not stated)
- Why this option was chosen
- Who was involved or needs to know
- **Reversibility:** Is this a one-way door (irreversible, high-stakes) or two-way door (reversible, low-risk)?
- **Blast radius:** What systems, teams, or customers are affected?
- **Time horizon:** When does this decision expire or need revisiting?

### Step 2: Classify the decision
- **Strategic**: roadmap direction, platform evolution, market positioning
- **Tactical**: sprint scope, priority order, resource allocation
- **Technical**: architecture, API design, integration approach
- **Process**: workflow changes, ceremony changes, team structure

### Step 3: Check for conflicts (automatic)
Before recording, cross-reference:
- your decisions log (check conversation context): contradicting prior decisions
- your Jira epics (use Atlassian MCP jira_search): related work that might be affected
- your docs/decisions folder: related decision records
- search Slack for [decision topic keywords]: prior discussions, commitments, or context that might conflict
- your recent OneNote notes: any different commitment made in a recent meeting?
- **Atlassian fallback:** If Atlassian MCP is available, search Jira for related tickets. If MCP fails (401/403), use local data.

**If a conflict exists:** Flag it prominently before recording. State what the prior decision was, when it was made, and ask to confirm this is a deliberate reversal or an update.

### Step 4: Assess decision quality
Before recording, quickly evaluate:

| Check | Pass? |
|-------|-------|
| Alternatives were genuinely considered (not strawmen) | ✅/❌ |
| Rationale addresses the *strongest* argument for alternatives | ✅/❌ |
| Blast radius is bounded and understood | ✅/❌ |
| Reversibility is assessed honestly | ✅/❌ |
| The right people were involved | ✅/❌ |

If any check fails, flag it: "This decision may be premature because [X]. Want to proceed or revisit?"

### Step 5: Record the decision
Append to your decisions log:
```
### [Date], [Decision Title]
- **Decision:** What was decided
- **Type:** Strategic / Tactical / Technical / Process
- **Reversibility:** One-way door / Two-way door
- **Alternatives:** What else was considered
- **Rationale:** Why this option
- **Strongest counter-argument:** The best case for a different choice, and why we still went this way
- **Blast radius:** What's affected
- **Stakeholders:** Who was involved, who needs to know
- **Revisit by:** [Date or trigger condition. When should we reconsider?]
- **Source:** Meeting name, conversation, or "stated directly"
```

### Step 6: Route outputs
Write a decision record to your docs system or Confluence via MCP.
- Save as .docx using python-docx (preferred for shareable docs)

### Step 7: Offer follow-ups
- "Want me to draft a stakeholder update about this decision?" → `/update`
- "Should I check what Jira tickets are affected?" → search and list
- "Want me to pressure-test this before we commit?" → `/pressure-test`

## Self-Verification (run before recording)
Before saving the decision, verify:
- [ ] Conflict check was actually run against the decisions log, Slack, and Jira
- [ ] At least 2 alternatives are documented (even if obvious)
- [ ] Strongest counter-argument is stated. Not just "other options were considered"
- [ ] Reversibility assessment is honest. One-way doors get extra scrutiny
- [ ] Blast radius names specific teams/systems, not just "may affect others"
- [ ] Revisit condition is set. No decision lives forever without review

## Rules
- If the decision is vague, ask ONE clarifying question before recording.
- Always assess reversibility. This changes how much scrutiny the decision deserves.
- Never silently overwrite a prior decision. Flag the contradiction and ask.
- Use concise language. The decision log is a reference, not a narrative.
- One-way door decisions get a mandatory `/pressure-test` offer before recording.
- **Workflow links:** After recording, also offer: `/impact-analysis` (assess blast radius of the decision), `/stakeholder-brief` (brief affected stakeholders), `/risk-register` (update risks from this decision), `/jira` (create tickets for implementation work).
