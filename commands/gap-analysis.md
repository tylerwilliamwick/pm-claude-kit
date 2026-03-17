Use after `/plan-review` on implementation plans, when you say "gap analysis", "check for defects", "what could break", "find bugs in the plan", "implementation risks", or "audit this plan". Catches code-level defects in implementation plans before approving execution.

## Arguments
$ARGUMENTS -- optional: "deep" to force Deep mode (architect + critic), "code" to force implementation track, "pm" to force PM track (exits immediately), or specific plan text/path to analyze. If no arguments, analyzes the most recent plan in conversation context.

## Your task

### Phase 0: Classify Input + Budget Check

**Context budget gate:**
Check `.omc/state/hud-stdin-cache.json` for `used_percentage`.
- If > 80%: refuse. Output: "Context at {X}%. Gap analysis needs room for agent dispatch. Run `/clear` first or start a fresh session."
- If > 60%: warn. Output: "Context at {X}%. Gap analysis needs room for agent dispatch. Suggest `/clear` first or run in a fresh session." Then proceed.

**Plan discovery:**
1. Current conversation context (look for implementation plan text)
2. `~/.claude/plans/` (most recent by mtime)
3. `.omc/plans/` (most recent by mtime)
4. If nothing found, ask what to analyze.

**Plan type classification:**

| Track | Detection Signals |
|-------|------------------|
| Code Implementation Plan | File paths, function/class names, import references, `.claude/plans/*.md` files, module names, API endpoint definitions, database schema changes |
| PM Deliverable | Everything else: PRDs, stakeholder comms, roadmap artifacts, decisions, analyses |

If $ARGUMENTS includes "code" or "pm", use that override. Otherwise auto-detect.

**If plan type = PM-only and no `code` override:**
Skip gap-analysis entirely. Output: "This is a PM deliverable. `/plan-review` and `/pressure-test` cover this. Run `/gap-analysis code` to force implementation analysis." Stop here.

**Depth selection:**
- If $ARGUMENTS includes "deep": Deep mode
- If the plan touches 5+ files: Deep mode
- If the plan modifies public APIs: Deep mode
- Otherwise: Standard mode

### Phase 1: Research (direct tool calls, no agents)

Run all of these in parallel:

1. **LSP diagnostics:** `lsp_diagnostics` on every file referenced in the plan
2. **AST search:** `ast_grep_search` for patterns the plan modifies or introduces
3. **Caller search:** `Grep` for callers of functions being changed
4. **Change velocity:** `git log --oneline -10` on each referenced file
5. **File existence:** Verify all referenced paths exist via `Glob` or `Read`

**Produce a Research Log:**

```
## Research Log
### Sources Investigated
| # | Source | Type | Result | Freshness |
|---|--------|------|--------|-----------|
| 1 | [source name] | [LSP/AST/Grep/Git/FileCheck] | [what was found] | [timestamp or age] |

### Key Findings from Research
- [finding with source # reference]

### Sources Unavailable
- [source]: [reason, e.g., file not found, LSP timeout]
```

This log is the shared evidence pool. Every finding in later phases must reference entries here.

### Phase 2: Agent Dispatch

**Depth controls agent usage:**

| Depth | Agents | Cost |
|-------|--------|------|
| Standard (default) | 1x `oh-my-claudecode:architect` (opus) | 1 opus call |
| Deep | 1x `oh-my-claudecode:architect` (opus), then 1x `oh-my-claudecode:critic` (opus) | 2 opus calls |

**Standard mode:**

Dispatch `oh-my-claudecode:architect` (opus) with:
- The full plan text
- The Phase 1 Research Log
- The 12-category defect taxonomy (listed below)
- Instruction: "For each category, assess whether the plan introduces a defect. Cite Research Log entries as evidence. Return structured findings with severity ratings."

**Deep mode:**

Run architect first (same as Standard). Then dispatch `oh-my-claudecode:critic` (opus) with:
- All architect findings
- The Research Log
- Instruction: "For each finding, evaluate: (1) Is this a real problem or theoretical? Would the user care? (2) Is the evidence solid? (3) Is the severity calibrated correctly? Return KEEP, DROP, or DOWNGRADE for each finding with a one-line rationale. You CANNOT UPGRADE any finding past its evidence-based severity cap."

**Severity cap rule:** Unverified findings (no Research Log evidence) cap at Medium. The critic pass can DOWNGRADE or DROP but never UPGRADE past the evidence cap.

### Defect Taxonomy (12 categories)

1. **Null/Undefined Handling** -- missing null checks, optional access on required fields, undefined state paths
2. **Race Conditions & Concurrency** -- async operations without guards, shared state mutation, timing dependencies
3. **Off-by-One & Boundary** -- array bounds, pagination edges, range comparisons, empty collection handling
4. **Breaking Changes to Callers** -- function signature changes, removed exports, renamed interfaces, changed return types
5. **Test Coverage Gaps** -- modified code without corresponding test updates, new paths without assertions, removed test coverage
6. **Logic Errors in Approach** -- incorrect algorithm, wrong conditional logic, misunderstood requirements in code
7. **Migration & Compatibility** -- schema changes without migration, version incompatibilities, rollback risks
8. **Integration Defects** -- API contract mismatches, incorrect payloads, missing auth headers, wrong endpoint paths
9. **Error Handling Gaps** -- uncaught exceptions, missing error paths, swallowed errors, incorrect error propagation
10. **Resource Leaks & Cleanup** -- unclosed connections, missing teardown, event listener accumulation, temp file orphans
11. **Security Implications** -- new input surfaces without validation, auth bypass paths, data exposure, injection vectors
12. **Observability Blind Spots** -- new code paths without logging, missing metrics, silent failure modes, untraceable errors

### Severity Framework

| Level | Definition | Evidence Requirement | Action |
|-------|-----------|---------------------|--------|
| Critical | Production incident, data loss, security breach | Must cite specific file, function, or data source from Research Log | Must fix before approving |
| High | Bug reaching QA/staging, dependency blocking another team | At least partially grounded in Research Log | Should fix before execution |
| Medium | Rework during implementation, test gap | Can be unverified. Cap for unverified findings. | Fix during implementation |
| Low | Code smell, minor edge case, theoretical | Assertion sufficient | Note for awareness |

**Severity cap:** Unverified findings (no Research Log evidence) cap at Medium. This is absolute.

### Phase 3: Generate Report

Present findings Critical-first:

```
## Gap Analysis: [Plan Title or File Name]
Plan type: implementation | Depth: standard/deep | Files analyzed: N

### Defects Found: N (X Critical, Y High, Z Medium, W Low)

#### Critical
[C1] **[Title]**
- Category: [from taxonomy]
- Where: [file:line or plan section]
- Scenario: [concrete failure case with business impact]
- Evidence: [Research Log entry #]
- Prevention: [specific action to take]

#### High
[same format]

#### Medium
[same format]

#### Low
[same format]

### Categories Checked (12)
| # | Category | Result |
|---|----------|--------|
| 1 | Null/Undefined Handling | Clean / [finding ref] |
| 2 | Race Conditions & Concurrency | Clean / [finding ref] |
| 3 | Off-by-One & Boundary | Clean / [finding ref] |
| 4 | Breaking Changes to Callers | Clean / [finding ref] |
| 5 | Test Coverage Gaps | Clean / [finding ref] |
| 6 | Logic Errors in Approach | Clean / [finding ref] |
| 7 | Migration & Compatibility | Clean / [finding ref] |
| 8 | Integration Defects | Clean / [finding ref] |
| 9 | Error Handling Gaps | Clean / [finding ref] |
| 10 | Resource Leaks & Cleanup | Clean / [finding ref] |
| 11 | Security Implications | Clean / [finding ref] |
| 12 | Observability Blind Spots | Clean / [finding ref] |

### What Passed
[Brief note on what looks solid]

### Research Log
[Full research log from Phase 1]
```

If Deep mode ran, append:

```
### Critic Review
| Finding | Architect Severity | Critic Verdict | Rationale |
|---------|-------------------|----------------|-----------|
| [C1] | Critical | KEEP / DROP / DOWNGRADE | [one-line rationale] |
```

### Phase 4: Route Outputs

**Plan mode check:** If plan mode is active:
- Phases 1-2 run normally (read-only tools and agent dispatch)
- Write findings as an appendix section in the active plan file
- Skip .docx and docs routing
- Output: "Full report routing deferred until plan mode exits."
- Stop here.

**Normal mode routing:**

1. **Save as .docx** via python-docx to `~/Documents/gap-analysis-[plan-name]-[date].docx`

2. **If Critical or High findings exist:**
   Write the gap analysis to your docs system or Confluence via MCP.

3. **Follow-up suggestion:**
   - If Critical or High found: "Amend the plan to address these defects, then re-run `/gap-analysis`."
   - If all Clean or Medium/Low only: "Plan looks solid at the code level. Suggest `/jira` to turn it into tickets."

## Self-Verification (run before presenting the report)

Before showing findings, verify:
- [ ] Research Log has at least 3 distinct sources investigated
- [ ] Every Critical and High finding cites a specific Research Log entry
- [ ] No Critical or High finding is Unverified (severity cap applied)
- [ ] Every finding includes a concrete failure scenario with business impact
- [ ] All 12 categories appear in the coverage table
- [ ] Voice compliance: no dashes as punctuation, no banned words from rules/voice.md
- [ ] Deep mode critic trail included (if Deep mode ran)
- [ ] .docx generated
- [ ] Follow-up suggestion matches findings (amend vs. /jira)

## Rules
- Be direct. The value is in surfacing defects that would waste engineering time or cause production issues.
- Ground findings in the Research Log. "Function `getUser()` at auth/service.ts:42 has 6 callers (Research Log #3) and the plan changes its return type without updating them" is useful. "There might be breaking changes" is not.
- Unverified findings cap at Medium. No exceptions.
- Frame every finding in business impact terms. The user is a PM, not a developer.
- No em dashes in the report output. No banned words.
- Skip this command entirely for PM deliverables unless forced with "code".
- After the gap analysis, offer: `/jira` (if clean), or amend-and-rerun (if defects found).
