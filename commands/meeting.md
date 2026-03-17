Use when you have a meeting coming up or just finished one. Trigger on "meeting prep", "prep me for", "meeting recap", "action items from meeting", "what did we commit to".

## Your task

Handle before-meeting prep and after-meeting processing.

### Sub-commands

This command requires an explicit sub-command. If the user just says "meeting" without specifying, ask: "Prepping for a meeting or processing one that just happened?"

#### `/meeting prep [name]`

Before a meeting. Read ~/.claude/commands/meeting-prep.md and follow its full structure.

If meeting-prep.md is not available:
1. Check your calendar for the meeting details
2. Pull related Jira tickets, Confluence pages, and prior meeting notes
3. Check Circleback for transcripts from prior instances of this recurring meeting
4. Surface: agenda items, open questions, decisions needed, talking points
5. Flag risks or topics to raise proactively

#### `/meeting recap [notes]`

After a meeting. Process notes or transcript provided:
1. Extract action items with owners and deadlines
2. Extract decisions made (who decided, what, any conditions)
3. Extract follow-ups needed (who, what, by when)
4. Read ~/.claude/commands/action-items.md for action item extraction patterns
5. Use Atlassian MCP to create Jira tasks from action items when action items map to [YOUR_PROJECT] work
6. Write the meeting record to your docs/meetings folder or Confluence via MCP

### Rules
- Action items must have an owner and a deadline. If the notes don't specify, ask
- Decisions get logged via /decision if they're significant
- Don't create Jira tickets without confirmation on scope and assignment

$ARGUMENTS
