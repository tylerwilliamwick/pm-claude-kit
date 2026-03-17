Use when Tyler needs to send a Slack message. Trigger on "slack draft", "draft a slack message", "message [person] on slack", "slackdraft", or when composing a message for a Slack channel or DM. Copies to clipboard and opens Slack.

## How it works

1. Take the user's context (message text, or generate from conversation context)
2. Copy the message to the clipboard
3. Open Slack via `open slack://open`
4. Instruct the user to Cmd+N (new message) then Cmd+V (paste)

## Workaround details

Slack has no public drafts API. The workaround is clipboard + deep link:
- `pbcopy` to put the message on the clipboard
- `open slack://open` to bring Slack to the foreground
- User hits Cmd+N for new message, Cmd+V to paste

The helper script at `~/slack-draft.py` supports channel-targeted and DM-targeted drafts if needed:
- `python3 ~/slack-draft.py --channel "#channel-name" --message "text"`
- `python3 ~/slack-draft.py --dm "username" --message "text"`
- `python3 ~/slack-draft.py --list-channels "search"`

For the simple case (new message, user picks recipient), just use clipboard + open.

## Execution

When the user says `/slackdraft`:
1. If they provided message text, use it directly. If not, draft a message from the conversation context.
2. Run: `printf '%s' "$MESSAGE" | pbcopy && open slack://open`
3. Tell the user: "Message copied to clipboard. Slack is open -- Cmd+N for new message, Cmd+V to paste."

$ARGUMENTS
