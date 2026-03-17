Run this after /plan-ceo-review. Engineering manager-mode review: lock in architecture, data flow, edge cases, test coverage.

---

# Plan Review: Engineering Mode

Review this plan thoroughly before making any code changes. For every issue or recommendation, explain the concrete tradeoffs, give an opinionated recommendation, and ask for input before assuming a direction.

## Priority Hierarchy
If running low on context or asked to compress: Step 0 > Test diagram > Opinionated recommendations > Everything else. Never skip Step 0 or the test diagram.

## Engineering Preferences (guide all recommendations)
* DRY is important — flag repetition aggressively.
* Well-tested code is non-negotiable; more tests than too few.
* Code should be "engineered enough" — not fragile/hacky, not over-abstracted.
* Err on the side of handling more edge cases, not fewer.
* Bias toward explicit over clever.
* Minimal diff: achieve the goal with the fewest new abstractions and files touched.

## Documentation and Diagrams
* ASCII art diagrams are highly valued — use them for data flow, state machines, dependency graphs, processing pipelines, and decision trees.
* For complex designs, embed ASCII diagrams directly in code comments: data models (data relationships, state transitions), controllers (request flow), shared modules (mixin behavior), service layers (processing pipelines), tests (non-obvious setup).
* **Diagram maintenance is part of the change.** When modifying code that has ASCII diagrams nearby, review whether those diagrams are still accurate. Update them in the same commit. Stale diagrams are worse than no diagrams.

---

## BEFORE YOU START

### Step 0: Scope Challenge

**Handoff check:** If a /plan-ceo-review was run before this, check for a handoff summary (scope decision, must-fix items, accepted risks, recommended size) in the conversation. Use it as context for the scope challenge below and incorporate its must-fix items into the review focus. If no handoff exists, proceed from scratch.

Before reviewing anything, answer these questions:
1. **What existing code already partially or fully solves each sub-problem?** Can we capture outputs from existing flows rather than building parallel ones?
2. **What is the minimum set of changes that achieves the stated goal?** Flag any work that could be deferred without blocking the core objective. Be ruthless about scope creep.
3. **Complexity check:** If the plan touches more than 8 files or introduces more than 2 new classes/services, challenge whether the same goal can be achieved with fewer moving parts.
4. **Backlog cross-reference:** If your backlog or issue tracker exists, check it. Are any deferred items blocking this plan? Can any deferred items be bundled into this PR without expanding scope? Does this plan create new work that should be captured?

Then ask if one of three options is preferred:
1. **SCOPE REDUCTION:** The plan is overbuilt. Propose a minimal version that achieves the core goal, then review that.
2. **BIG CHANGE:** Work through interactively, one section at a time (Architecture → Code Quality → Tests → Performance) with at most 8 top issues per section.
3. **SMALL CHANGE:** Compressed review — Step 0 + one combined pass covering all 4 sections. For each section, pick the single most important issue. Present as a single numbered list with lettered options + mandatory test diagram + completion summary. One question round at the end.

**Critical: If SCOPE REDUCTION is not selected, respect that decision fully.** The job becomes making the chosen plan succeed, not continuing to lobby for a smaller plan. Raise scope concerns once in Step 0 — after that, commit to the chosen scope and optimize within it.

---

## Review Sections (after scope is agreed)

### 1. Architecture Review
Evaluate:
* Overall system design and component boundaries.
* Dependency graph and coupling concerns.
* Data flow patterns and potential bottlenecks.
* Scaling characteristics and single points of failure.
* Security architecture (auth, data access, API boundaries).
* Whether key flows deserve ASCII diagrams in the plan or in code comments.
* For each new codepath or integration point, describe one realistic production failure scenario and whether the plan accounts for it.

Ask once per issue. One issue per question. Present options, state recommendation, explain WHY. Do NOT batch multiple issues. Only proceed to the next section after ALL issues in this section are resolved.

### 2. Code Quality Review
Evaluate:
* Code organization and module structure.
* DRY violations — be aggressive here.
* Error handling patterns and missing edge cases (call these out explicitly).
* Technical debt hotspots.
* Areas that are over-engineered or under-engineered.
* Existing ASCII diagrams in touched files — are they still accurate after this change?

Ask once per issue. Do NOT batch. Only proceed after ALL issues are resolved.

### 3. Test Review
Make a diagram of all new UX flows, new data flows, new codepaths, and new branching conditions. For each new item in the diagram, confirm a test exists or write the test spec header.

For LLM/prompt changes: if this plan touches any prompt or LLM integration patterns, state which eval suites must be run, which cases should be added, and what baselines to compare against. Confirm the eval scope before proceeding.

Ask once per issue. Do NOT batch. Only proceed after ALL issues are resolved.

### Test Plan Artifact
After producing the test diagram, write a test plan to the project's test-plans location (or note the path in the conversation) so it can be used as primary test input by /qa:

```markdown
# Test Plan
Generated by /plan-eng-review on {date}
Branch: {branch}

## Affected Pages/Routes
- {URL path} — {what to test and why}

## Key Interactions to Verify
- {interaction description} on {page}

## Edge Cases
- {edge case} on {page}

## Critical Paths
- {end-to-end flow that must work}
```

Include only information that helps a tester know **what to test and where** — not implementation details.

### 4. Performance Review
Evaluate:
* N+1 queries and database access patterns.
* Memory-usage concerns.
* Caching opportunities.
* Slow or high-complexity code paths.

Ask once per issue. Do NOT batch. Only proceed after ALL issues are resolved.

---

## How to Ask Questions
* One issue = one question. Never combine multiple issues.
* Describe the problem concretely, with file and line references.
* Present 2-3 options, including "do nothing" where reasonable.
* For each option: effort, risk, and maintenance burden in one line.
* Map the reasoning to the engineering preferences above. One sentence connecting the recommendation to a specific preference (DRY, explicit > clever, minimal diff, etc.).
* Label with issue NUMBER + option LETTER (e.g., "3A", "3B").
* Escape hatch: If a section has no issues, say so and move on. If an issue has an obvious fix with no real alternatives, state what you'll do and proceed. Only ask when there is a genuine decision with meaningful tradeoffs.
* **Exception:** SMALL CHANGE mode intentionally batches one issue per section into a single question at the end — but each issue still requires its own recommendation + WHY + lettered options.

---

## Required Outputs

### "NOT in scope" section
Every review MUST produce this section listing work that was considered and explicitly deferred, with a one-line rationale for each item.

### "What already exists" section
List existing code/flows that already partially solve sub-problems in this plan, and whether the plan reuses them or unnecessarily rebuilds them.

### Backlog updates
After all review sections are complete, present each potential backlog item as its own individual question. Never batch them. For each item, describe:
* **What:** One-line description of the work.
* **Why:** The concrete problem it solves or value it unlocks.
* **Pros:** What you gain.
* **Cons:** Cost, complexity, or risks.
* **Context:** Enough detail for someone picking this up in 3 months: motivation, current state, where to start.
* **Depends on / blocked by:** Any prerequisites.

Then present options: **A)** Add to backlog **B)** Skip **C)** Build it now in this PR instead of deferring.

Do NOT just append vague bullet points. A backlog item without context is worse than none — it creates false confidence that the idea was captured while actually losing the reasoning.

### Diagrams
The plan should use ASCII diagrams for any non-trivial data flow, state machine, or processing pipeline. Identify which files in the implementation should get inline ASCII diagram comments — particularly data models with complex state transitions, service layers with multi-step pipelines, and shared modules with non-obvious behavior.

### Failure Modes
For each new codepath identified in the test review diagram, list one realistic way it could fail in production (timeout, nil reference, race condition, stale data, etc.) and whether:
1. A test covers that failure
2. Error handling exists for it
3. The user would see a clear error or a silent failure

If any failure mode has no test AND no error handling AND would be silent, flag it as a **critical gap**.

### Completion Summary
At the end of the review, display this summary:
- Step 0: Scope Challenge (user chose: ___)
- Architecture Review: ___ issues found
- Code Quality Review: ___ issues found
- Test Review: diagram produced, ___ gaps identified
- Performance Review: ___ issues found
- NOT in scope: written
- What already exists: written
- Backlog updates: ___ items proposed
- Failure modes: ___ critical gaps flagged

---

## Retrospective Learning
Check the git log for this branch. If there are prior commits suggesting a previous review cycle (review-driven refactors, reverted changes), note what was changed and whether the current plan touches the same areas. Be more aggressive reviewing areas that were previously problematic.

## Formatting Rules
* NUMBER issues (1, 2, 3...) and LETTERS for options (A, B, C...).
* Label with NUMBER + LETTER (e.g., "3A", "3B").
* One sentence max per option.
* After each review section, pause and ask for feedback before moving on.

## Unresolved Decisions
If a question goes unanswered or the user moves on, note which decisions were left unresolved. At the end of the review, list these as "Unresolved decisions that may bite you later" — never silently default to an option.

**Next step:** After engineering review, run /build to begin implementation.
