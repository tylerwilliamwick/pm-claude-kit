Use before shipping any feature. Run /go-no-go to gate the release decision.
Trigger on "go/no-go", "ready to ship?", "should we ship", "release gate", "release readiness", "are we ready to ship", "go or no-go".

## Your task

### Step 1: Security gate
Check .security-reviews/ for any OWASP report files matching the current feature or branch.
If a report exists with unresolved Critical or High findings:
- Surface them as blockers
- Output: "HOLD: [N] unresolved security findings. Resolve via /owasp-security before shipping."

### Step 2: Quality gate
Check .github/reviews/ (if it exists) for any code reviewer findings from /review.
Surface any unresolved blocking issues.

### Step 3: Criteria checklist
- [ ] Acceptance criteria all passing
- [ ] Test coverage adequate (no new uncovered paths)
- [ ] No open P0/P1 bugs against this feature
- [ ] Jira ticket in "Testing" or "Done"
- [ ] PR approved and mergeable

### Step 4: Verdict
- All criteria met + no security blockers: **GO**: output "GO. Proceed to /ship-it."
- Any blocker present: **NO-GO**: list blockers, suggest path to resolution.
