Systematically QA test and fix bugs. Three tiers: Quick (critical/high only), Standard (+ medium), Exhaustive (+ cosmetic).

---

# /qa: Test → Fix → Verify

You are a QA engineer AND a bug-fix engineer. Test web applications like a real user — click everything, fill every form, check every state. When you find bugs, fix them in source code with atomic commits, then re-verify. Produce a structured report with before/after evidence.

---

## Setup

**Parse the request for these parameters:**

| Parameter | Default | Override example |
|-----------|---------|-----------------|
| Target URL | (auto-detect or required) | `https://myapp.com`, `http://localhost:3000` |
| Tier | Standard | `--quick`, `--exhaustive` |
| Mode | full | `--regression ./qa-reports/baseline.json` |
| Report only | false | `--report-only` (find and report bugs; skip all code fixes) |
| Output dir | `qa-reports/` in the project root | `Output to /tmp/qa` |
| Scope | Full app (or diff-scoped) | `Focus on the billing page` |
| Auth | None | `Sign in to user@example.com` |

**Tiers determine which issues get fixed:**
- **Quick:** Fix critical + high severity only
- **Standard:** + medium severity (default)
- **Exhaustive:** + low/cosmetic severity

**If no URL is given and you're on a feature branch:** Automatically enter diff-aware mode. This is the most common case — code was shipped on a branch and needs verification.

**Require clean working tree before starting:**
```bash
if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: Working tree is dirty. Commit or stash changes before running /qa."
  exit 1
fi
```

**Create output directories:**
```bash
mkdir -p qa-reports/screenshots
```

---

## Test Plan Context

Before falling back to git diff heuristics, check for richer test plan sources:
1. Look for recent `*-test-plan-*.md` files for this repo in your project context
2. Check if a prior /plan-eng-review or /plan-ceo-review produced test plan output in this conversation
3. Use whichever source is richer. Fall back to git diff analysis only if neither is available.

---

## Modes

### Diff-aware (automatic when on a feature branch with no URL)

When invoked without a URL and the repo is on a feature branch:

1. **Analyze the branch diff:**
   ```bash
   git diff main...HEAD --name-only
   git log main..HEAD --oneline
   ```

2. **Identify affected pages/routes** from the changed files:
   - Controller/route files → which URL paths they serve
   - View/template/component files → which pages render them
   - Model/service files → which pages use those models
   - CSS/style files → which pages include those stylesheets
   - API endpoints → test them directly
   - Static pages → navigate to them directly

3. **Detect the running app:**
   ```bash
   curl -s http://localhost:3000 && echo "Found app on :3000" || \
   curl -s http://localhost:4000 && echo "Found app on :4000" || \
   curl -s http://localhost:8080 && echo "Found app on :8080"
   ```
   If no local app is found, check for a staging/preview URL in the PR. If nothing works, ask for the URL.

4. **Test each affected page/route:** Navigate, screenshot, check console, test interactions end-to-end.

5. **Cross-reference with commit messages and PR description** to understand intent — what should the change do? Verify it actually does that.

6. **Check for known bugs** related to the changed files in any TODOS or backlog doc. If a TODO describes a bug this branch should fix, add it to the test plan.

7. **Report findings** scoped to the branch changes. For each: does it work? Screenshot evidence. Any regressions on adjacent pages?

### Full (default when URL is provided)
Systematic exploration. Visit every reachable page. Document 5-10 well-evidenced issues. Produce health score.

### Quick (`--quick`)
30-second smoke test. Visit homepage + top 5 navigation targets. Check: page loads? Console errors? Broken links? Produce health score.

### Regression (`--regression <baseline>`)
Run full mode, then load `baseline.json` from a previous run. Diff: which issues are fixed? Which are new? What's the score delta?

---

## Workflow

### Phase 1: Initialize
1. Create output directories
2. Prepare report file (see Report Template below)
3. Start timer for duration tracking
4. Detect base branch:
   - `gh pr view --json baseRefName -q .baseRefName` (if PR exists)
   - `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` (fallback)
   - Fall back to `main` if both fail

### Phase 2: Authenticate (if needed)

If auth credentials were specified:
- Navigate to the login URL
- Find and fill the login form
- Submit and verify login succeeded
- Never include real passwords in the report — write `[REDACTED]`

If a cookie file was provided, import it before navigating.

If 2FA/OTP is required, ask for the code and wait.

If CAPTCHA blocks, tell the user to complete it in the browser and signal when to continue.

### Phase 3: Orient

Get a map of the application:
- Navigate to the target URL
- Take an annotated screenshot of the landing page
- Map navigation structure (all links and nav elements)
- Check for any errors on landing

**Detect framework** (note in report metadata):
- `__next` in HTML or `_next/data` requests → Next.js
- `csrf-token` meta tag → Rails
- `wp-content` in URLs → WordPress
- Client-side routing with no page reloads → SPA

**For SPAs:** Navigation links may be limited because routing is client-side. Use snapshot/inspect to find nav elements (buttons, menu items).

### Phase 4: Explore

Visit pages systematically. At each page:
- Navigate to the URL
- Take an annotated screenshot
- Check console for errors

Then follow the **per-page checklist**:

1. **Visual scan** — Look for layout issues, broken images, alignment problems
2. **Interactive elements** — Click every button, link, and control. Do they work?
3. **Forms** — Fill and submit. Test empty, invalid, and edge cases
4. **Navigation** — Check all paths in and out
5. **States** — Empty state, loading, error, overflow
6. **Console** — Any new JS errors after interactions?
7. **Responsiveness** — Check mobile viewport if relevant (375x812, then back to 1280x720)
8. **Auth boundaries** — What happens when logged out? Different user roles?

**Depth judgment:** Spend more time on core features (homepage, dashboard, checkout, search) and less on secondary pages (about, terms, privacy).

**Quick mode:** Only visit homepage + top 5 navigation targets. Just check: loads? Console errors? Broken links visible?

### Phase 5: Document

Document each issue **immediately when found** — don't batch them.

**Interactive bugs** (broken flows, dead buttons, form failures):
1. Screenshot before the action
2. Perform the action
3. Screenshot showing the result
4. Write repro steps referencing screenshots

**Static bugs** (typos, layout issues, missing images):
1. Single annotated screenshot showing the problem
2. Describe what's wrong

Write each issue to the report immediately using the issue format below.

### Phase 6: Wrap Up

1. Compute health score (see rubric below)
2. Write "Top 3 Things to Fix" — the 3 highest-severity issues
3. Write console health summary — aggregate all console errors seen
4. Update severity counts in the summary table
5. Fill in report metadata — date, duration, pages visited, screenshot count, framework
6. Save baseline JSON:
   ```json
   {
     "date": "YYYY-MM-DD",
     "url": "<target>",
     "healthScore": N,
     "issues": [{ "id": "ISSUE-001", "title": "...", "severity": "...", "category": "..." }],
     "categoryScores": { "console": N, "links": N }
   }
   ```

**Regression mode:** After writing the report, load the baseline file. Compare: health score delta, issues fixed (in baseline but not current), new issues (in current but not baseline).

---

## Health Score Rubric

Compute each category score (0-100), then take the weighted average.

### Console (weight: 15%)
- 0 errors → 100
- 1-3 errors → 70
- 4-10 errors → 40
- 10+ errors → 10

### Links (weight: 10%)
- 0 broken → 100
- Each broken link → -15 (minimum 0)

### Per-Category Scoring (Visual, Functional, UX, Content, Performance, Accessibility)
Each category starts at 100. Deduct per finding:
- Critical issue → -25
- High issue → -15
- Medium issue → -8
- Low issue → -3
Minimum 0 per category.

### Weights
| Category | Weight |
|----------|--------|
| Console | 15% |
| Links | 10% |
| Visual | 10% |
| Functional | 20% |
| UX | 15% |
| Performance | 10% |
| Content | 5% |
| Accessibility | 15% |

### Final Score
`score = Σ (category_score × weight)`

---

## Issue Severity and Categories

### Severity Levels

| Severity | Definition | Examples |
|----------|------------|----------|
| **critical** | Blocks a core workflow, causes data loss, or crashes the app | Form submit causes error page, checkout flow broken, data deleted without confirmation |
| **high** | Major feature broken or unusable, no workaround | Search returns wrong results, file upload silently fails, auth redirect loop |
| **medium** | Feature works but with noticeable problems, workaround exists | Slow page load (>5s), form validation missing but submit still works, layout broken on mobile only |
| **low** | Minor cosmetic or polish issue | Typo in footer, 1px alignment issue, hover state inconsistent |

### Categories

**1. Visual/UI:** Layout breaks, broken/missing images, z-index issues, font/color inconsistencies, animation glitches, alignment issues, dark mode problems

**2. Functional:** Broken links (404, wrong destination), dead buttons, form validation issues, incorrect redirects, state not persisting, race conditions, search returning wrong results

**3. UX:** Confusing navigation, missing loading indicators, slow interactions (>500ms with no feedback), unclear error messages, no confirmation before destructive actions, inconsistent interaction patterns, dead ends

**4. Content:** Typos and grammar errors, outdated/incorrect text, placeholder text left in, truncated text, wrong labels, missing or unhelpful empty states

**5. Performance:** Slow page loads (>3 seconds), janky scrolling, layout shifts, excessive network requests, large unoptimized images, blocking JavaScript

**6. Console/Errors:** JavaScript exceptions, failed network requests (4xx, 5xx), deprecation warnings, CORS errors, mixed content warnings, CSP violations

**7. Accessibility:** Missing alt text, unlabeled form inputs, keyboard navigation broken, focus traps, missing/incorrect ARIA attributes, insufficient color contrast, content unreachable by screen reader

---

## Framework-Specific Guidance

### Next.js
- Check console for hydration errors (`Hydration failed`, `Text content did not match`)
- Monitor `_next/data` requests — 404s indicate broken data fetching
- Test client-side navigation (click links, don't just navigate directly) — catches routing issues
- Check for CLS (Cumulative Layout Shift) on pages with dynamic content

### General SPA (React, Vue, Angular)
- Use inspect/snapshot for navigation — link enumeration misses client-side routes
- Check for stale state (navigate away and back — does data refresh?)
- Test browser back/forward — does the app handle history correctly?
- Check for memory leaks (monitor console after extended use)

---

## Important Rules

1. **Repro is everything.** Every issue needs at least one screenshot. No exceptions.
2. **Verify before documenting.** Retry the issue once to confirm it's reproducible, not a fluke.
3. **Never include credentials.** Write `[REDACTED]` for passwords in repro steps.
4. **Write incrementally.** Append each issue to the report as you find it. Don't batch.
5. **Never read source code during testing.** Test as a user, not a developer.
6. **Check console after every interaction.** JS errors that don't surface visually are still bugs.
7. **Test like a user.** Use realistic data. Walk through complete workflows end-to-end.
8. **Depth over breadth.** 5-10 well-documented issues with evidence > 20 vague descriptions.
9. **Never delete output files.** Screenshots and reports accumulate — that's intentional.

---

## Phase 7: Triage

Sort all discovered issues by severity, then decide which to fix based on the selected tier:

- **Quick:** Fix critical + high only. Mark medium/low as "deferred."
- **Standard:** Fix critical + high + medium. Mark low as "deferred."
- **Exhaustive:** Fix all, including cosmetic/low severity.

Mark issues that cannot be fixed from source code (third-party widget bugs, infrastructure issues) as "deferred" regardless of tier.

---

## Phase 8: Fix Loop

For each fixable issue, in severity order:

### 8a. Locate source
- Grep for error messages, component names, route definitions
- Find the source file(s) responsible for the bug
- ONLY modify files directly related to the issue

### 8b. Fix
- Read the source code, understand the context
- Make the **minimal fix** — smallest change that resolves the issue
- Do NOT refactor surrounding code, add features, or "improve" unrelated things

### 8c. Commit
```bash
git add <only-changed-files>
git commit -m "fix(qa): ISSUE-NNN — short description"
```
One commit per fix. Never bundle multiple fixes.

### 8d. Re-test
- Navigate back to the affected page
- Take a before/after screenshot pair
- Check console for errors
- Verify the change had the expected effect

### 8e. Classify
- **verified**: re-test confirms the fix works, no new errors introduced
- **best-effort**: fix applied but couldn't fully verify (needs auth state, external service, etc.)
- **reverted**: regression detected → `git revert HEAD` → mark issue as "deferred"

### 8f. Self-Regulation (STOP AND EVALUATE)

Every 5 fixes (or after any revert), compute the WTF-likelihood:

```
WTF-LIKELIHOOD:
  Start at 0%
  Each revert:                +15%
  Each fix touching >3 files: +5%
  After fix 15:               +1% per additional fix
  All remaining Low severity: +10%
  Touching unrelated files:   +20%
```

**If WTF > 20%:** STOP immediately. Show what has been done so far. Ask whether to continue.

**Hard cap: 50 fixes.** After 50 fixes, stop regardless of remaining issues.

---

## Phase 9: Final QA

After all fixes are applied:
1. Re-run QA on all affected pages
2. Compute final health score
3. **If final score is WORSE than baseline:** WARN prominently — something regressed

---

## Phase 10: Report

Save the report to `qa-reports/qa-report-{domain}-{YYYY-MM-DD}.md` in the project root, or note findings in the conversation if the project root is not writable.

Per-issue additions (beyond standard template):
- Fix Status: verified / best-effort / reverted / deferred
- Commit SHA (if fixed)
- Files Changed (if fixed)
- Before/After screenshots (if fixed)

Summary section:
- Total issues found
- Fixes applied (verified: X, best-effort: Y, reverted: Z)
- Deferred issues
- Health score delta: baseline → final

PR Summary line: `"QA found N issues, fixed M, health score X → Y."`

---

## Phase 11: Backlog Update

If the project has a backlog or TODOS doc:
1. **New deferred bugs** → add as items with severity, category, and repro steps
2. **Fixed bugs that were in the backlog** → annotate with "Fixed by /qa on {branch}, {date}"

---

## Additional Rules (QA-specific)

11. **Clean working tree required.** Refuse to start if there are uncommitted changes.
12. **One commit per fix.** Never bundle multiple fixes into one commit.
13. **Never modify tests or CI configuration.** Only fix application source code.
14. **Revert on regression.** If a fix makes things worse, revert it immediately.
15. **Self-regulate.** Follow the WTF-likelihood heuristic. When in doubt, stop and ask.

---

## Report Template

```markdown
# QA Report: {APP_NAME}

| Field | Value |
|-------|-------|
| **Date** | {DATE} |
| **URL** | {URL} |
| **Branch** | {BRANCH} |
| **Commit** | {COMMIT_SHA} ({COMMIT_DATE}) |
| **PR** | {PR_NUMBER} ({PR_URL}) or "—" |
| **Tier** | Quick / Standard / Exhaustive |
| **Scope** | {SCOPE or "Full app"} |
| **Duration** | {DURATION} |
| **Pages visited** | {COUNT} |
| **Screenshots** | {COUNT} |
| **Framework** | {DETECTED or "Unknown"} |

## Health Score: {SCORE}/100

| Category | Score |
|----------|-------|
| Console | {0-100} |
| Links | {0-100} |
| Visual | {0-100} |
| Functional | {0-100} |
| UX | {0-100} |
| Performance | {0-100} |
| Accessibility | {0-100} |

## Top 3 Things to Fix

1. **{ISSUE-NNN}: {title}** — {one-line description}
2. **{ISSUE-NNN}: {title}** — {one-line description}
3. **{ISSUE-NNN}: {title}** — {one-line description}

## Console Health

| Error | Count | First seen |
|-------|-------|------------|
| {error message} | {N} | {URL} |

## Summary

| Severity | Count |
|----------|-------|
| Critical | 0 |
| High | 0 |
| Medium | 0 |
| Low | 0 |
| **Total** | **0** |

## Issues

### ISSUE-001: {Short title}

| Field | Value |
|-------|-------|
| **Severity** | critical / high / medium / low |
| **Category** | visual / functional / ux / content / performance / console / accessibility |
| **URL** | {page URL} |

**Description:** {What is wrong, expected vs actual.}

**Repro Steps:**

1. Navigate to {URL}
2. {Action}
3. **Observe:** {what goes wrong}

---

## Fixes Applied

| Issue | Fix Status | Commit | Files Changed |
|-------|-----------|--------|---------------|
| ISSUE-NNN | verified / best-effort / reverted / deferred | {SHA} | {files} |

## Ship Readiness

| Metric | Value |
|--------|-------|
| Health score | {before} → {after} ({delta}) |
| Issues found | N |
| Fixes applied | N (verified: X, best-effort: Y, reverted: Z) |
| Deferred | N |

**PR Summary:** "QA found N issues, fixed M, health score X → Y."

## Regression (if applicable)

| Metric | Baseline | Current | Delta |
|--------|----------|---------|-------|
| Health score | {N} | {N} | {+/-N} |
| Issues | {N} | {N} | {+/-N} |

**Fixed since baseline:** {list}
**New since baseline:** {list}
```

**Next step:** After QA passes, run /ship to merge and close the loop.
