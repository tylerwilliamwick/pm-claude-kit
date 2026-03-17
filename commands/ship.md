Use when the PR is reviewed, QA is complete, and it's time to merge and close the loop.
Trigger on "ship", "merge it", "deploy", "merge the PR", "close this out".

## Your task

1. **Pre-ship check**
   - Run `gh pr checks` to confirm all CI checks pass
   - Confirm the PR is not in draft state: `gh pr view --json isDraft -q .isDraft`
   - If Atlassian MCP is configured, check for any linked Jira stories still "In Review" and offer to transition them to Done; otherwise check manually

2. **Go/No-Go gate**
   Ask: "All checks passing. Ticket status: {status}. Ship it?"
   - If yes: proceed to merge
   - If no: note what needs fixing and stop

3. **Merge**
   Merge using your team's preferred strategy (squash, merge, or rebase). Example using squash:
   ```bash
   gh pr merge --squash --auto
   ```

4. **Post-merge ticket close**
   If Atlassian MCP is configured, transition any linked Jira stories from "In Review" to "Done"; otherwise update tickets manually.

5. **Record ship date**
   Note the merged PR URL and ship date in the conversation for retro and doc-update context.

**Next step:** Run /doc-update to update your changelog and docs.
