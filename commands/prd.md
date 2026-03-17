Use when a PRD, spec, or requirements doc is needed. Trigger on "write a PRD", "draft requirements for", "I need a PRD", or when a feature idea, problem statement, or initiative needs to be formalized into a structured requirements document.

Use this structure exactly:

## Problem Statement
What problem are we solving and why does it matter now?

## Who Is Affected
List each affected user type (internal teams, customers, admins, engineers) and how they're impacted. Include estimated scale (how many users/agencies).

## Current State
What exists today? What's broken, missing, or limiting? Ground this in real data from research.

## Desired Outcome
What does success look like? Include measurable success criteria where possible (adoption targets, performance thresholds, reduction in support tickets, etc.).

## Constraints
Technical, timeline, compliance, or dependency constraints that bound the solution.

## Proposed Approach
Describe the solution approach. If multiple options exist, list them with brief tradeoffs before recommending one. Include a "simplest version first" option. What's the minimum that delivers meaningful value?

## Acceptance Criteria
Numbered list of testable, specific conditions that must be true for this to be considered done. Write these so an engineer can estimate against them. Each AC must be independently verifiable. No compound conditions.

## Sizing Signal
Estimate rough scope: Quick Win (hours-days, 1-2 epics) / Sprint-Scale (1-4 weeks, 3-8 epics) / Program (1-3+ months, 9+ epics). Note confidence level and what could change the estimate.

## Risks and Dependencies
List known risks, unknowns, and cross-team dependencies. Flag anything that could block or delay delivery. For each risk, state likelihood (H/M/L) and impact (H/M/L).

## Migration and Compatibility
If this changes existing behavior: what's the migration path? Backward compatibility requirements? Feature flag strategy? Rollout considerations?

## Open Questions
List unresolved questions that need answers before or during implementation. For each, note who can answer it and whether it blocks starting work.

---

## Pre-Draft Research (automatic)
Before drafting, draw from context provided in the conversation and any Jira/Confluence data available via MCP.

- If Atlassian MCP is available, fetch current Jira/Confluence data for richer context. If MCP fails (401/403), note the limitation and proceed from conversation context.
- Cross-reference findings: does Jira say one thing and the conversation another? Flag it.
- Check whether any prior decision mentioned in the conversation conflicts with this PRD's approach.

Incorporate relevant findings into the draft. Use them to ground the Current State section and identify constraints/dependencies not explicitly mentioned.

---

## Self-Verification Checklist (run before presenting)
Before showing the PRD, verify internally:
- [ ] Problem statement answers "why now?" not just "what?"
- [ ] Every AC is independently testable. No "and" conditions that bundle multiple checks
- [ ] Risks section includes at least one dependency risk, one technical risk, and one customer risk
- [ ] No assumptions are hiding as facts. If something is assumed, it's flagged with ⚠️
- [ ] Sizing signal is included with honest confidence level
- [ ] Customer-visible outcome is stated (even for internal platform work)
- [ ] Migration/compatibility is addressed (even if "N/A. Net new capability")
- [ ] At least one "simplest version" option is described

If any check fails, fix it before presenting. Do not present a PRD that fails self-verification.

---

Rules:
- No filler content. Every sentence earns its place.
- Flag any assumptions not explicitly stated. Mark them with ⚠️ ASSUMPTION.
- If the input is vague, ask one clarifying question before drafting.
- Write acceptance criteria that an engineer can directly estimate against.
- Connect internal platform work to customer-visible outcomes wherever applicable.
- Save the final PRD as .docx using python-docx. Also display in conversation.
- After saving, offer to run `/pressure-test` on the draft.
- **Workflow links:** After drafting, offer: `/pressure-test` (stress-test the PRD), `/jira` (convert to stories), `/plan-ceo-review` (validate scope before committing).

**Next step:** Run /plan-ceo-review to validate scope, then /jira to break into stories.
