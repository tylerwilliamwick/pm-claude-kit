Use at sprint end, PI boundary, or when you ask "what shipped", "release notes", "what did we deliver", or when customers or leadership need a summary of recent delivery. Also use after a deployment or when drafting a release announcement.

Use at sprint end, PI boundary, or when customers/leadership ask "what shipped?"

## Arguments
$ARGUMENTS: optional: "customer" for external-facing, "internal" for engineering detail, "both" for both versions, or a sprint/PI name to target. Default: both

## Your task

### Step 1: Gather delivery data (automatic)
**Pre-computed intelligence (check first):**
- `~/overnight-tasks/output/release-notes-draft/`: latest overnight release notes draft (use as starting point, enhance with live data)

**Live data:**
- your Jira board (use Atlassian MCP jira_search): current sprint completions
- recent Jira activity (use Atlassian MCP jira_search): recently resolved tickets
- your Jira epics (use Atlassian MCP jira_search): epic-level completions
- GitHub merged PRs (use GitHub MCP mcp__github__list_commits or mcp__github__get_pull_request for implementation detail)
- your Confluence space (use Atlassian MCP confluence_search): roadmap items that shipped
- your recent OneNote notes: notes on what shipped
- your decisions log (check conversation context): decisions that shaped what shipped
- search Slack for [shipped OR released OR deployed OR merged OR completed]: team announcements
- **Atlassian fallback:** If Atlassian MCP is available, query for recently resolved tickets and sprint completion data. If MCP fails (401/403), use local data.

### Step 2: Categorize changes
Group completed work into:
- **New Features**: net-new capability for users
- **Enhancements**: improvements to existing features
- **Bug Fixes**: defects resolved
- **Infrastructure/Platform**: non-user-facing improvements
- **Security**: security fixes or hardening (note: never include vulnerability details in customer version)
- **Known Issues**: issues discovered but not yet resolved

### Step 3: Generate release notes

#### Customer-Facing Version
```markdown
# Release Notes: [Version/Sprint/Date]
**Release date:** [date]

## What's New
- **[Feature Name]**: [1-2 sentence plain-language description of what users can now do]

## Improvements
- **[Enhancement Name]**: [what got better and why users care]

## Fixes
- **[Fix Description]**: [what was broken and what users should expect now]

## Known Issues
- [Issue], [workaround if available, expected fix timeline]
```

#### Internal Version
```markdown
# Internal Release Notes: [Version/Sprint/Date]
**Sprint:** [name] | **Team:** [YOUR_TEAM] | **Release date:** [date]

## Delivered
| Ticket | Type | Summary | Epic | Notes |
|--------|------|---------|------|-------|

## Metrics
- **Stories completed:** [X] ([Y] points)
- **Bugs resolved:** [X] (breakdown by severity)
- **Carry-over:** [X] stories ([Y] points)
- **Completion rate:** [X]%
- **vs. commitment:** [X]% of sprint commitment delivered

## Notable Technical Changes
- [Architectural decisions, dependency updates, infrastructure changes]

## Deployment Notes
- [Anything ops/support needs to know]
- [Config changes, migration steps, feature flags]
- [Rollback considerations]

## Customer Impact
- SF cases resolved by this release: [list]
- Agencies specifically waiting on this: [list]

## Deferred to Next Sprint
| Ticket | Reason | New Target |
|--------|--------|-----------|
```

### Step 4: Route outputs
- Save both versions as .docx using python-docx
- Write to your docs/projects folder or Confluence via MCP

## Self-Verification (run before presenting)
Before showing the notes, verify:
- [ ] Customer version uses plain language. No ticket numbers, no jargon, no internal acronyms
- [ ] Internal version includes specific ticket refs and point counts
- [ ] Bug fixes describe the symptom (what was broken), not just the fix
- [ ] Security items in customer version mention the fix without disclosing the vulnerability
- [ ] Known issues include workarounds where available
- [ ] Metrics include vs-commitment comparison (not just raw numbers)
- [ ] Customer impact section lists waiting cases

## Rules
- Customer version: plain language, no jargon, no ticket numbers. Focus on what users can DO now.
- Internal version: include ticket refs, points, and technical detail.
- Never include security vulnerability details in customer-facing notes.
- If a feature shipped but isn't GA (behind a flag), note it in internal only.
- Group related fixes under a single user-visible description rather than listing every ticket.
- Bug fix descriptions should be outcome-oriented: "Permit search now returns results for records with special characters" not "Fixed null pointer in SearchDAO.java"
- **Workflow links:** After generating, offer: `/stakeholder-brief` (announce the release to leadership), `/customer-signal` (check how shipped features are being received), `/velocity-insight` (track delivery trends), `/update` (draft a release announcement).
