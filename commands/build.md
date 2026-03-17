Use when implementation is ready to commit, push, and open for review.
Trigger on "build", "commit and push", "open a PR", "ready for review", "submit for review", "ship this code".

## Your task

1. Run available tests based on project type:
   - Node/JS: npm test
   - Python: pytest
   - Java/Maven: mvn test -pl [module]
   - If no test runner detected: skip and note it
2. If tests pass: stage all changes, commit with a PM-legible message referencing the Jira ticket key
3. Push the branch
4. Open a draft PR on GitHub — description includes: what changed, why, Jira ticket link
5. Post the PR URL as a comment on the Jira ticket via Atlassian MCP
6. Transition Jira ticket to "In Review" via Atlassian MCP
7. Suggest /code-review as the next step
