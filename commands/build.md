Use when implementation is ready to commit, push, and open for review.
Trigger on "build", "commit and push", "open a PR", "ready for review", "submit for review", "ship this code".

## Your task

1. Run available tests based on project type:
   - Node/JS: npm test
   - Python: pytest
   - Java/Maven: mvn test -pl [module]
   - If no test runner detected: skip and note it
2. If tests pass: stage all changes, commit with a clear, descriptive commit message referencing the relevant ticket or issue number
3. Push the branch
4. Open a draft PR on GitHub — description includes: what changed, why, ticket or issue reference
5. If Jira MCP is available, post the PR URL as a comment on the ticket and transition it to "In Review"; otherwise update the ticket manually
6. Confirm the PR URL in the conversation for the next step

**Next step:** Run /code-review once the PR is open.
