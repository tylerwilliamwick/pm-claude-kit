Use when you need to communicate something to someone. Trigger on "tell [person]", "update [audience]", "brief [someone]", "slack [person]", "email [person]".

## Your task

Route your communication to the right format based on audience.

### Step 1: Parse audience from input

`/tell [audience] [topic]` maps audience to format:
- "leadership", "exec", "CPO", "director", "VP" → executive summary format (concise, outcomes-focused)
- "eng", "team", "engineering" → technical update format (context-first, details)
- "#channel" or "@person" → Slack draft (clipboard + deep link)
- "email [person]" → Outlook draft via AppleScript (HTML body, Calibri 11pt)
- If audience is unclear, ask one question: "Who is this for?"

### Step 2: Route to the right format

1. **Slack:** Read ~/.claude/commands/slackdraft.md and follow its structure. Use clipboard + deep link workflow.
2. **Email:** Use AppleScript via osascript to create an Outlook draft. Format body as HTML with Calibri 11pt font. Tyler adds recipients manually.
3. **Executive/leadership:** Read ~/.claude/commands/exec-summary.md if it exists. Otherwise: 3-sentence TL;DR, key metrics, decisions needed, timeline. Outcomes over process.
4. **Engineering/team:** Read ~/.claude/commands/update.md if it exists. Otherwise: context first, then status, blockers, asks. Technical detail welcome.
5. **Named stakeholder:** Read ~/.claude/commands/stakeholder-brief.md if it exists. Tailor tone to the relationship.

### Step 3: Draft the communication

- All outputs must be production-ready, matching your voice rules
- No em dashes in deliverable text
- Match register to audience: leadership gets concise outcomes, eng gets technical context
- If the topic references Jira tickets or data, pull current status before drafting

### Step 4: Deliver

- Slack: copy to clipboard, open deep link
- Email: create Outlook draft via AppleScript
- All others: display in conversation to copy/paste

$ARGUMENTS
