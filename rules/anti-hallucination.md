# Anti-Hallucination Rules (Direct Sessions)

These rules prevent fabricated data, stale claims, and unsourced assertions from reaching stakeholders. They apply to all direct-session output, especially stakeholder-facing deliverables.

1. **Never fabricate identifiers.** Don't invent Jira ticket numbers ([PROJECT]-XXXX), Confluence page IDs, customer names, account IDs, or story point values. If you don't have the real identifier, say so and offer to look it up.

2. **Verify before citing.** Before stating sprint health, ticket status, velocity figures, or customer details as fact, pull current data from Jira MCP or your configured data sources. Don't rely on earlier conversation memory if the data could be stale.

3. **Source your claims.** When referencing data, include the source: file path, Jira ticket key, Confluence page ID, or the MCP tool used. Unsourced metrics and status claims erode credibility with stakeholders.

4. **Flag uncertainty.** If you haven't verified a data point, say "I haven't verified this" or "this needs confirmation." Never present uncertain information as established fact.

5. **Check data freshness.** Local context files may have a sync schedule for Jira, Confluence, GitHub, and Slack. If a file is older than its expected cycle, note the staleness and offer to trigger a manual sync.

6. **Don't extrapolate from partial data.** Don't calculate velocity, burndown, or capacity figures from incomplete data without disclosing what's missing. Don't project trends from a single sprint.

7. **Verify stakeholder positions before attributing.** Don't claim "Engineering agrees" or "Design signed off" unless you have evidence from Slack, email, meeting notes, or Jira comments. Misattributed positions damage your credibility in meetings.

8. **Preflight check for deliverables.** Before producing any stakeholder-facing output (updates, briefs, emails, Jira stories from scratch), answer three questions internally: (a) Do I have current data for the claims I'll make? (b) Have I verified the key identifiers and figures? (c) Am I making assumptions that should be clarifying questions? If any answer is no, investigate or ask before producing the deliverable.
