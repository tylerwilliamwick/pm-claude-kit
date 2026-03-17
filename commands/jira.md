Use when Jira stories, epics, or tickets need to be written. Trigger on "write stories for", "create tickets", "break this into stories", "jira", or when a PRD, feature description, or requirement needs to become sprint-ready work items.

For each epic, provide:
- **Epic title** (short, outcome-oriented)
- **Epic description**: 2-3 sentences on what this accomplishes and why
- **Definition of Done for Epic**: What must be true for the epic to close

For each story under the epic:
- **Story title**
- **User story**: "As a [role], I want [capability], so that [outcome]"
- **Acceptance Criteria**: numbered list of verifiable conditions. Each AC independently testable, no compound "and" conditions
- **Notes for Engineering**: context that doesn't fit in AC but matters for implementation (dependencies, known edge cases, migration considerations, existing code to be aware of)
- **Story point estimate**: Fibonacci (1,2,3,5,8,13) with one-line rationale
- **Story size signal**: flag if the story is likely too large to estimate cleanly and suggest how to decompose it
- **Dependencies**: other stories/epics this blocks or is blocked by

---

## Pre-Draft Research (automatic)
Before writing stories:
- Check your synced company context if available, otherwise work from context provided in the conversation
- If Atlassian MCP is available, fetch current Jira data to check for duplicates and existing stories. If MCP fails (401/403), note the limitation and proceed from conversation context.
- Reference existing ticket IDs where dependencies exist (e.g., "Depends on [YOUR_PROJECT_KEY]-XXX").

---

## Decomposition Rules
Apply these sizing heuristics to every story:

**Red flags. Story is too big:**
- >8 points → must decompose
- Multiple user roles in one story → split by role
- "AND" in the story title → likely 2+ stories
- AC list >8 items → story covers too much
- Multiple API endpoints or services touched → split by service boundary
- Both frontend and backend changes required → consider splitting

**Good decomposition patterns:**
- Split by user action (create vs. edit vs. delete)
- Split by happy path vs. error handling
- Split by UI vs. API vs. data migration
- Spike story first when technical approach is uncertain (timeboxed to 1-3 days)

**Dependency ordering:**
- API stories before UI stories that consume them
- Data migration stories before feature stories that depend on new schema
- Spike/research stories before implementation stories

---

## Self-Verification (run before presenting)
Before showing the stories, verify:
- [ ] No duplicate of an existing ticket (checked available context)
- [ ] Every story ≤8 points (decompose if not)
- [ ] Every AC is independently testable. No "and" bundling
- [ ] Dependencies are explicit and reference real ticket IDs where possible
- [ ] Cross-team dependencies flagged in Notes for Engineering
- [ ] Story titles are outcome-oriented, not task-oriented ("Enable X" not "Implement Y")
- [ ] Estimated total points are reasonable vs. team velocity

---

Rules:
- Default project key: `[YOUR_PROJECT_KEY]`. Default team: `[YOUR_TEAM_NAME]`. Update these to match your Jira setup.
- Default to one epic with 3-6 stories unless scope clearly warrants more.
- "As a developer/engineer" is acceptable when that's the real user.
- Acceptance criteria must be testable. No vague language like "works correctly" or "is improved."
- Flag cross-team dependencies explicitly in Notes for Engineering.
- Flag any story >8 points and suggest decomposition.
- If the total estimated effort seems >1 sprint, call it out and suggest phasing.
- After generating, offer to save as importable JSON. If Atlassian MCP is available and working, also offer to push directly to Jira. If MCP is broken (401/403), skip the offer and save JSON only.
- **Workflow links:** After generating stories, offer: `/dependency-map` (map cross-team dependencies for the new work), `/qa` (generate test cases from the acceptance criteria), `/plan-eng-review` (brief engineering on the new scope).

**Next step:** After stories are created, run /build to start implementation or /plan-eng-review to gate the approach.
