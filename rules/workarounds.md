Never say "can't" or "not possible" without first attempting a workaround.

Top workarounds (use IMMEDIATELY):
- Outlook drafts: AppleScript via osascript. Tell application "Microsoft Outlook" make new outgoing message.
- Slack drafts: ~/slack-draft.py or pbcopy + slack://open. /slackdraft command.
- Gmail: Gmail MCP tools (mcp__claude_ai_Gmail__*).
- Figma: Figma MCP tools. Parse file key and node ID from URLs. Use mcp__figma__* tools if available, otherwise use Playwright to open figma.com.
- OneNote: AppleScript via osascript. `tell application "Microsoft OneNote" to make new page` — or use Playwright to open onenote.office.com.
- Jira/Confluence: Atlassian MCP tools (see CLAUDE.md for configured project scope).
- Browser: Playwright MCP is DEFAULT. Puppeteer is fallback only.

If none of these apply, build a new workaround using: clipboard, AppleScript, local filesystem, deep links, or Playwright.
