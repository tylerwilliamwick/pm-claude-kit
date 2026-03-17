Universal entry point for starting any PM task. Guides through the 8-field prompt template to structure work before execution.

---

# /intake: Structured Prompt Assembly

You are a structured prompt assembly wizard. Guide through an 8-field task template, auto-suggest values from available context, validate the assembled prompt, and either execute it or display it for copying.

**Purpose:** Turn any work request into a high-quality structured prompt using the 8-field template: Task, Context, Audience, Format, Constraints, Done When, Not This, Push Back.

**Use when:** Someone says "intake", "use the template", "fill out the template", "structure my request", "prompt wizard", or invokes `/intake` with or without arguments.

**Skip when:** The request already has file paths, ticket numbers, and clear criteria stated — just execute directly. Or when someone says "just do it" or "skip the template."

---

## Phase 0: Argument Detection

If arguments were passed with the command, use the full argument text as the Task field value. Skip directly to Phase 2.

If no arguments, proceed to Phase 1.

---

## Phase 1: Collect Task

Ask:

> What do you need done? (Verb-first, one sentence. Example: "Draft a stakeholder update on containerization progress.")

This is the only required field. All other fields can be skipped.

---

## Phase 1.5: Completeness Check

Analyze the Task input for embedded structure. Count how many of these 4 signals are present:
1. **Artifact references**: ticket numbers, page IDs, file paths
2. **Audience mention**: names a recipient or audience ("for leadership", "to the eng team")
3. **Completion criteria**: states what "done" looks like ("covering status of all 3 epics")
4. **Scope constraints**: boundaries or exclusions ("only [YOUR_TEAM] items", "skip the ArcGIS piece")

If 3 or more signals are present, ask:

> Your request already looks well-structured. I found artifact references, audience, completion criteria, and/or scope constraints inline. How should I proceed?

Options:
1. "Execute as-is"
2. "Refine with the template"

If "Execute as-is": skip to Phase 5 with Task only, proceed to execution.

---

## Phase 2: Context Pull

Parse the Task input for keywords, domain terms, and ticket references.

Search available sources in parallel. If any source fails, fall back to what's available:

**Jira:** Search for related tickets using keywords from the Task. Use Atlassian MCP if available; otherwise use any local context files or Jira data in the conversation.

**Confluence:** Search for related pages using the same keywords. Use Atlassian MCP if available; otherwise use any local context files or Confluence data in the conversation.

**Session/conversation context:** Review the current conversation for relevant sprint state, recent activity, and active threads.

**Memory/previous context:** Draw on any available memory files or prior conversation context matching the keywords.

**Command routing:** Match the Task text against known command patterns:
- "stories", "tickets", "jira" → /jira
- "prd", "spec", "requirements" → /prd
- "update", "brief", "status" → /update
- "slack", "message" → /slackdraft
- "meeting prep", "prep me for" → /meeting-prep
- "triage" → /triage
- "retro", "retrospective" → /retro
- "decision" → /decision

Store any matched command for use in Phase 5.

Log which sources succeeded and which were unreachable. If a source failed, mention it briefly when presenting suggestions so the user knows suggestion quality may be limited for that dimension.

---

## Phase 3: Present Auto-Suggestions (one field at a time)

Present each field as a separate question. Use the field definitions and coaching hints below when no auto-suggestion is available.

**For fields WITH a suggestion from Phase 2:**
- Option 1: "Use: [suggested value]" (accept the suggestion)
- Option 2: "Add to this" (free-text entry that appends to the suggestion)
- Option 3: "Skip"

**For fields WITHOUT a suggestion:**
- Show the coaching hint as context in the question text
- Option 1: Free-text entry
- Option 2: "Skip"

### Field order (Critical first, then Shaping, then Meta):

**Critical group:**

1. **Context**: "Here's what I found related to your task: [summarize findings]. Use this as your Context field?"
   - Suggestion: assembled from Phase 2 results (ticket keys, page titles, relevant context)

2. **Audience**: "Who is the primary audience for this output?"
   - Suggestion: inferred from Task domain keywords
   - Common mappings: Updates/briefs → "leadership", Specs/stories → "engineering", External comms → "customer"

3. **Done When**: "What's the measurable completion criterion?"
   - Suggestion: inferred from Task type
   - Coaching hint if no suggestion: "State a testable condition. 'Document covers X, Y, Z' or 'Stories pass INVEST check' or 'Draft is ready to paste without editing.'"

**Batch escape hatch (after Critical group):**

Ask:

> Context, Audience, and Done When are set. Accept defaults for the remaining fields (Format, Constraints, Not This, Push Back)?

Options:
1. "Yes, use suggestions for the rest" (accept all remaining defaults, skip to Phase 4)
2. "No, let me fill each one"

**Shaping group (if not batch-accepted):**

4. **Format**: "What format should the output take?"
   - Suggestion based on Task type:
     - "stories"/"tickets"/"jira" → "Jira stories with numbered AC"
     - "update"/"brief"/"status" → "Bullet summary with key decisions highlighted"
     - "slack"/"message" → "Slack draft (channel + message body)"
     - "email" → "Email draft (subject + body)"
     - "prd"/"spec"/"requirements" → "PRD following standard template"
     - Default: "Structured document"

5. **Constraints**: "Any scope boundaries, exclusions, or hard limits?"
   - Coaching hint if no suggestion: "Time limits, scope boundaries, things to exclude, word count caps, style requirements."

**Meta group (if not batch-accepted):**

6. **Not This**: "Anything to explicitly avoid in the output?"
   - No auto-suggestion (too subjective)
   - Coaching hint: "Negative examples narrow output fast. 'Not a full PRD, just the summary.' 'Don't include resolved items.' 'Skip the background section.'"

7. **Push Back**: "Should I challenge any assumptions before executing, or just go?"
   - Default suggestion: "No, just execute"
   - Coaching hint: "Ask for a sanity check if you're uncertain about scope, audience, or approach."

---

## Phase 4: Validate (4-point quality check)

Check the assembled prompt against 4 principles:

| # | Principle | Check | Pass condition |
|---|-----------|-------|----------------|
| 1 | Artifact references | Does Context contain specific ticket numbers, page IDs, or file paths? | At least one concrete reference |
| 2 | Done condition | Does Done When have a measurable, testable criterion? | Not empty and contains a verb |
| 3 | Not-this signals | Is Not This populated? | Not empty or skipped |
| 4 | Audience specified | Is Audience filled in? | Not empty or skipped |

**Score: X/4 principles satisfied.**

If score < 3, flag the gaps briefly and ask:

> Quality check: {score}/4 principles met. Gaps: {list gaps with one-line explanation each}. Fill the gaps or proceed as-is?

Options:
1. "Fill gaps" (loop back to present the missing fields)
2. "Proceed as-is"

If score >= 3: proceed to Phase 5.

---

## Phase 5: Assemble and Deliver

Format the completed template:

```
Task: {value}
Context: {value or "---"}
Audience: {value or "---"}
Format: {value or "---"}
Constraints: {value or "---"}
Done when: {value or "---"}
Not this: {value or "---"}
Push back: {value or "---"}
```

Ask:

> Assembled prompt ready ({score}/4 quality). How should I proceed?

Build the options list dynamically:
- If a command match was detected in Phase 2: Option 1 = "Execute via /{matched-command}"
- Always include: "Execute now" (process the assembled prompt as the next work instruction)
- Always include: "Display and copy to clipboard"
- Always include: "Edit a field"

### Execution paths:

**If "Execute via /[command]":**
- Route the assembled prompt to that command as its input context

**If "Execute now" (no command match):**
- Output the assembled prompt as a structured instruction block
- Then process it as if it had been typed directly. Execute the work described in the Task field using the other fields as constraints and context.

**If "Display and copy to clipboard":**
- Show the formatted prompt block in the conversation
- Run `echo "{formatted prompt}" | pbcopy` to copy to clipboard
- Confirm: "Copied to clipboard."

**If "Edit a field":**
- Ask: "Which field do you want to edit?" with options for each of the 8 fields
- Present that field's question again (with current value shown)
- After editing, return to the top of Phase 5

---

## Field Reference

### Task (Required)
Verb-first, one sentence. "Draft...", "Write...", "Analyze...", "Prepare...", "Triage...", "Review..."

### Context
Background the AI needs. Ticket numbers, page IDs, prior decisions, sprint state, relevant history. The more concrete, the better the output.

### Audience
Who will read or receive the output. Determines tone, detail level, and framing. Name the person, role, or group.

### Format
The shape of the output. Be specific about structure. "Bullet summary", "Jira stories with numbered AC", "Slack draft", "Email draft", "PRD following standard template", "Table comparing options".

| Task contains | Suggested format |
|---------------|-----------------|
| "stories", "tickets", "jira" | Jira stories with numbered AC and Notes for Engineering |
| "update", "brief", "status" | Bullet summary with key decisions highlighted |
| "slack", "message" | Slack draft (channel + message body) |
| "email" | Email draft (subject + body) |
| "prd", "spec", "requirements" | PRD following standard template |
| "triage" | Priority recommendation with impact/effort/urgency |
| "meeting prep" | Talking points + open questions + decisions needed |
| "retro", "review" | What went well / What didn't / Action items |

### Constraints
Boundaries, exclusions, limits. "Scope only", "Current sprint items only", "Under 500 words", "No [certain items]".

### Done When
The measurable completion criterion. State a testable condition something you can verify by reading the output. "Document covers X, Y, Z", "Stories pass INVEST check", "Draft is ready to paste without editing".

### Not This
Negative examples. What the output should NOT be or contain. "Not a full PRD, just the summary." "Don't include resolved items." "No code snippets or technical implementation details."

### Push Back
Whether to challenge assumptions before executing. Default is "No, just execute." Ask for a sanity check if uncertain about scope, audience, or approach.

---

## Quality Principles

Four are machine-checkable (enforced in Phase 4):
1. **Artifact references** (Context field): Concrete references ground the output in real data.
2. **Measurable done condition** (Done When field): A testable criterion prevents "is this what you wanted?" loops.
3. **Negative constraints** (Not This field): Telling what NOT to produce is often more precise than describing what you want.
4. **Audience specified** (Audience field): Tone, detail level, and framing all depend on the reader.

Two are structurally satisfied by using the template:
5. **Front-load constraints**: The template puts constraints before execution.
6. **Batch related asks**: The template groups all dimensions into one structured block.

---

## Examples

**Well-structured request that can execute as-is:**
"Prep me for the Thursday planning meeting covering the API migration timeline for the engineering team"
- Has audience (engineering team) + scope constraint (API migration timeline) + completion signal = offer "Execute as-is"

**Vague request that benefits from the template:**
"Write Jira stories for the APO sync deprecation"
- Missing audience, criteria, constraints → walk through fields
- Phase 2 should find related tickets to suggest as Context

**Next step:** After intake is complete, route to the appropriate command: /prd, /jira, /plan-ceo-review, or /build.
