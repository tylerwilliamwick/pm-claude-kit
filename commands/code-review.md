Use when implementation is committed and pushed and a PR is open. Runs a structured code review.
Trigger on "code review", "review the PR", "review this branch", "code-review".

## Your task

1. **Identify the PR**
   - If a PR URL is provided as an argument, use it directly
   - Otherwise run `gh pr view --json url,headRefName,title` to find the open PR for the current branch

2. **Dispatch code reviewer**
   Launch the `oh-my-claudecode:code-reviewer` agent (model: sonnet) against the PR diff.
   Pass as context:
   - PR URL or branch name
   - What the change does (from the PR description or current conversation)
   - Any Jira ticket reference

3. **Findings**
   The code-reviewer produces severity-rated findings:
   - **Critical**: must fix before merge
   - **High**: should fix before merge
   - **Medium**: fix in a follow-up PR
   - **Low/Cosmetic**: optional

4. **Next step**
   - If no Critical or High findings: suggest `/qa` to run pre-ship testing
   - If Critical or High findings exist: address them, then re-run `/code-review`
