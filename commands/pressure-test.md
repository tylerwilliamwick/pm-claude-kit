Use when you say "pressure-test this", "poke holes in this", "what am I missing", "challenge this", or present a plan, proposal, or initiative that needs skeptical review before committing. Also use when a proposal feels too clean or assumptions are unstated.

Your job is to stress-test my thinking -- not to validate it.

## Arguments
$ARGUMENTS -- required: the plan, proposal, or initiative to pressure-test

## Your task

### Step 1: Gather context (automatic)
**Pre-computed intelligence (check first):**
- `~/overnight-tasks/output/sprint-health/` -- latest sprint health snapshot (team capacity reality)
- `~/overnight-tasks/output/scope-drift/` -- recent scope changes (is this piling onto drift?)
- `~/overnight-tasks/output/customer-signals/` -- customer signal analysis (does this align with customer needs?)

Before critiquing, silently check real data:
- your Jira epics (use Atlassian MCP jira_search) -- are the dependencies mentioned actually tracked? Any missed?
- your Jira board (use Atlassian MCP jira_search) -- is the team already overcommitted?
- your Confluence space (use Atlassian MCP confluence_search) -- do existing docs contradict or complicate this plan?
- your recent OneNote notes -- are there already-committed timelines or scope from meetings?
- your calendar -- are there imminent deadlines or PI events that affect timing?
- search Slack for [topic keywords] -- prior discussions, objections, failed attempts, or context that could invalidate assumptions
- your decisions log (check conversation context) -- prior decisions that constrain or conflict with this plan
- **Atlassian fallback:** If Atlassian MCP is available, try fetching full Jira/Confluence data for deeper analysis. If MCP fails (401/403), use the local synced data and note the limitation.

Ground your critique in real constraints, not hypothetical ones. "You have 3 epics already at-risk in sprint" hits harder than "you might be overcommitted."

### Step 2: Multi-perspective review

Evaluate the plan from 5 distinct perspectives. Each perspective asks different questions and catches different blind spots. Run these in parallel using sub-agents when possible.

**Engineering perspective** -- Think like the tech lead who has to build this.
- Is the technical approach sound? Are there simpler alternatives?
- What are the hidden implementation costs (data migration, backward compat, testing)?
- Does this create tech debt? Does it pay down existing debt?
- Are the estimates realistic given the team's codebase familiarity?
- What will the engineers push back on, and are they right?

**Executive perspective** -- Think like the VP who has to fund and defend this.
- Does this connect to a top-3 company priority? Can I explain why in one sentence?
- What's the opportunity cost -- what are we NOT doing by doing this?
- If this ships 2 months late, does anyone outside the team notice?
- Is this a "must have" or a "nice to have" dressed up as urgent?
- What does the board-level metric look like before and after?

**User researcher perspective** -- Think like the person who talks to customers daily.
- Is there evidence that users actually want this, or is it an internal assumption?
- Which user segment benefits most? Which gets nothing?
- Does this match how users describe the problem, or how we describe it?
- What's the learning curve? Will users discover this without hand-holding?
- Are there usability risks that won't surface until real users try it?

**Operations perspective** -- Think like the person who gets paged at 2 AM.
- Can this be deployed without downtime? What's the rollback plan?
- Does this add monitoring complexity? New alert surfaces?
- How does this affect support ticket volume -- up, down, or sideways?
- What's the runbook look like? Is the team ready to support this in production?
- For gov-tech: does this affect compliance posture or audit trail?

**Security/Compliance perspective** -- Think like the person who signs off on risk acceptance.
- Does this change the attack surface? New inputs, new endpoints, new integrations?
- Are there data handling implications (PII, multi-tenancy, audit logging)?
- Does this affect GovRAMP/FedRAMP compliance requirements?
- Are third-party dependencies introducing supply chain risk?
- Does the rollout plan include security review gates?

### Step 3: Work through analytical lenses

**Dependencies and sequencing**
- What must be true before this can start?
- Which dependencies are owned by other teams? Are those teams aware and committed?
- What happens if a dependency slips? What's the cascading impact?
- Is there a critical path, and is it the shortest one possible?

**Risk and failure modes**
- What are the 3 most likely ways this goes wrong?
- Are there backward compatibility or migration risks not addressed?
- What edge cases haven't been accounted for?
- Is there a rollback plan? If this fails in production, what happens?

**Scope and simplicity**
- Is there a simpler version that could ship first?
- What's the minimum that would deliver meaningful value?
- Am I conflating multiple separate problems?
- Could anything be deferred to a later phase without losing the core value?

**Stakeholder and customer impact**
- Who loses if this ships late?
- Who is affected that hasn't been mentioned?
- Is the customer-visible outcome clearly articulated?
- Does this align with what customers are actually asking for? (Check cases/signals)

**Assumptions**
- List every implicit assumption in the plan
- Score each: How confident are we (H/M/L)? How damaging if wrong (H/M/L)?
- Flag the top 3 riskiest assumptions (low confidence + high damage)

**Contradiction detection**
- Does Jira say one thing and Slack another about this area?
- Do prior decisions in the decisions log conflict with this direction?
- Was there a commitment made in a meeting that this plan contradicts?

### Step 4: Score overall confidence

Rate 1-10 on each dimension, then compute an overall confidence score:

| Dimension | Score | Notes |
|-----------|-------|-------|
| Feasibility (can we build it?) | /10 | |
| Clarity (is scope unambiguous?) | /10 | |
| Dependencies (are they managed?) | /10 | |
| Customer alignment (do they want this?) | /10 | |
| Team capacity (can we absorb this?) | /10 | |
| Risk mitigation (do we have a plan B?) | /10 | |
| **Overall confidence** | **/10** | weighted avg |

**Thresholds:**
- 8-10: Strong plan, proceed with normal governance
- 6-7: Viable but has gaps -- address findings before committing
- 4-5: Significant concerns -- consider redesigning or descoping
- 1-3: Fundamental issues -- do not proceed without major rework

### Step 5: Output

Present findings as:

```
## Pressure Test: [Title]
**Confidence Score:** X/10 -- [one-line verdict]
**Recommendation:** Proceed / Proceed with changes / Redesign / Do not proceed

## Multi-Perspective Flags
| Perspective | Key Concern | Severity |
|------------|-------------|----------|
| Engineering | [biggest technical risk] | H/M/L |
| Executive | [biggest strategic risk] | H/M/L |
| User Research | [biggest user risk] | H/M/L |
| Operations | [biggest operational risk] | H/M/L |
| Security | [biggest security/compliance risk] | H/M/L |

## Assumption Risk Matrix
| Assumption | Confidence | Damage if Wrong | Action |
|------------|-----------|-----------------|--------|

## Top 3 Concerns (ranked by impact)
1. [Concern] -- [Specific evidence from data] -- [Mitigation]
2. ...
3. ...

## Contradictions Found
- [Source A says X, Source B says Y -- which is true?]

## Confidence Scorecard
[Table from Step 4]

## If You Proceed Anyway
- Must resolve: [non-negotiable items]
- Should resolve: [important but can start without]
- Can defer: [address later without risk]
```

## Self-Verification (run before presenting)
Before showing findings, verify:
- [ ] Critique is grounded in real data, not hypotheticals -- at least 3 data-backed observations
- [ ] All 5 perspectives were genuinely considered (not just restating the same concern 5 ways)
- [ ] Assumptions are explicitly listed, not just implied
- [ ] "Simpler version" option was genuinely explored, not hand-waved
- [ ] Customer impact is assessed with real data (cases, signals), not guessed
- [ ] Contradiction check was actually run against the decisions log and Slack
- [ ] Top 3 concerns include specific mitigation recommendations
- [ ] Confidence score is calibrated -- not defaulting to safe middle range
- [ ] Multi-Perspective Flags table has distinct concerns per perspective (no duplicates)

## Rules
- Be direct. Don't soften findings to be polite.
- Ask clarifying questions if the input is too vague to assess.
- End with a ranked list of the top 3 things to resolve before moving forward.
- After the pressure test, offer to draft mitigation actions or run `/update` to communicate the plan to stakeholders.
- **Write to docs:** If the analysis reveals significant risks, write findings to your docs folder or Confluence via MCP.
- **Workflow links:** After the pressure test, offer: `/risk-register` (add newly surfaced risks), `/update` (communicate findings to stakeholders), `/assumption-check` (dig deeper into implicit assumptions), `/impact-analysis` (map blast radius of identified risks).
