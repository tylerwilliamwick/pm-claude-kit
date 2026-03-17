Use when documentation needs updating. Trigger on "update docs", "doc update", "update confluence", "update kb", "write an ADR", "update runbook".

## Your task

Update documentation in the right system based on the specified mode.

### Modes

Specify the mode in the command: `/doc-update [mode] [topic]`

#### `/doc-update confluence [topic]`
Update a Confluence page:
1. Search Confluence via Atlassian MCP for the existing page about [topic]
2. If found: read the current content, identify what needs updating, draft the changes
3. If not found: ask which space and parent page to create under
4. Use updateConfluencePage or createConfluencePage via Atlassian MCP
5. Confirm the update with a link to the page

#### `/doc-update kb [topic]`
Update a knowledge base article:
1. Search Confluence for KB articles about [topic]
2. Pull current content and identify gaps or stale information
3. Draft updates with current data from Jira, GitHub, or conversation context
4. Update via Atlassian MCP
5. If no KB article exists, offer to create one

#### `/doc-update adr [decision]`
Write an Architecture Decision Record:
1. Collect: context, decision, alternatives considered, consequences
2. Format as an ADR (title, date, status, context, decision, consequences)
3. Write to Confluence in the appropriate space
4. Update your configured docs destination (Confluence via MCP, or your local docs folder) with a copy
5. Offer to create a Jira ticket to track implementation if applicable

#### `/doc-update runbook [process]`
Update an operational runbook:
1. Search Confluence for the existing runbook about [process]
2. If found: read current steps, identify what changed, update
3. If not found: draft a new runbook with: purpose, prerequisites, step-by-step procedure, troubleshooting, escalation contacts
4. Update or create via Atlassian MCP
5. Flag if the runbook references outdated tools or procedures

#### `/doc-update local [topic]`
Update local repository documentation (README, ARCHITECTURE, CONTRIBUTING) after shipping a change. Based on the diff between the current branch and the base branch.

1. Check the current branch and diff:
   - `git branch --show-current`
   - `gh pr view --json baseRefName -q .baseRefName 2>/dev/null || echo "main"`
   - `git diff origin/<base> --stat`
   - `git diff origin/<base> --name-only`

2. Discover all documentation files in the repo:
   - Find all `.md` files up to 2 directories deep (exclude .git, node_modules)

3. Classify the diff changes into:
   - New features: new files, new services, new capabilities
   - Changed behavior: modified APIs, config changes, updated flows
   - Removed functionality: deleted files, removed commands or endpoints
   - Infrastructure: build, CI/CD, deployment changes

4. For each documentation file found, read it and cross-reference against the diff:

   **README.md:** Does it describe all capabilities visible in the diff? Are install/setup instructions still valid? Are examples accurate?

   **ARCHITECTURE.md:** Do component descriptions and diagrams match the current code? Only update things clearly contradicted by the diff — architecture docs should be conservative.

   **CONTRIBUTING.md:** Walk through setup instructions as a new contributor. Are listed commands accurate? Do test descriptions match the current test infrastructure?

   **CLAUDE.md / AGENTS.md / project instructions:** Does the project structure section match the actual file tree? Are listed commands and scripts accurate?

   **Any other .md files:** Read the file, determine its purpose, check if the diff contradicts anything it says.

5. Classify each needed update:
   - **Auto-update:** Factual corrections clearly warranted by the diff (add a row to a table, update a file path, fix a count, update a project structure tree). Apply these directly with Edit.
   - **Ask:** Narrative changes, section removal, large rewrites (more than ~10 lines in one section), ambiguous relevance. For each, describe what changed and why the doc needs updating, then ask.

6. Apply all auto-updates. Present ask items with a one-line description and a recommendation.

7. Output a summary: "Updated N files: [list]. Flagged M items for your review: [list]."

### Rules
- If mode is not specified, ask: "What kind of doc? (confluence, kb, adr, runbook, local)"
- Always search for existing docs before creating new ones. Duplicate docs are worse than no docs.
- Match the existing page's style and structure when updating.
- Note what changed and why in the version message.
- For `local` mode: if not in a git repo, ask to describe what changed instead of reading a diff.

$ARGUMENTS

**Next step:** After docs are updated, run /retro if this closes a sprint deliverable.
