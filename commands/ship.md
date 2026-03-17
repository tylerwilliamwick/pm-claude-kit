Use when the PR is reviewed, QA is complete, and it's time to merge and close the loop.
Trigger on "ship", "merge it", "deploy", "merge the PR", "close this out".

## Your task

1. **Pre-ship check**
   - Run `gh pr checks` to confirm all CI checks pass
   - Confirm the PR is not in draft state: `gh pr view --json isDraft -q .isDraft`
   - Check Atlassian MCP for any linked Jira stories still "In Review" — offer to transition them to Done

2. **Go/No-Go gate**
   Ask: "All checks passing. Jira stories: {status}. Ship it?"
   - If yes: proceed to merge
   - If no: note what needs fixing and stop

3. **Merge**
   ```bash
   gh pr merge --squash --auto
   ```
   Use `--squash` to keep history clean. If the PR has an explicit merge strategy in its description, use that instead.

4. **Post-merge Jira close**
   Transition any linked Jira stories from "In Review" to "Done" via Atlassian MCP (your configured Jira project scope).

5. **Record ship date**
   Note the merged PR URL and ship date in the conversation for retro and doc-update context.

6. Suggest `/doc-update local` as the next step to update CHANGELOG.md and local docs.
