Use when implementation is committed and pushed and a PR is open. Runs a structured code review.
Trigger on "code review", "review the PR", "review this branch", "code-review".

## Your task

1. **Identify the PR**
   - If a PR URL is provided as an argument, use it directly
   - Otherwise run `gh pr view --json url,headRefName,title` to find the open PR for the current branch

2. **Run structured review**
   Claude performs a structured review of the PR diff.
   Use as context:
   - PR URL or branch name
   - What the change does (from the PR description or current conversation)
   - Any ticket or issue reference

3. **Findings**
   Produce severity-rated findings:
   - **Critical**: must fix before merge
   - **High**: should fix before merge
   - **Medium**: fix in a follow-up PR
   - **Low/Cosmetic**: optional

**Next step:** If no critical/high findings: run /qa. If blockers found: address them and re-review.
