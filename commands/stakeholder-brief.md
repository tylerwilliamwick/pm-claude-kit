Use when you need to brief a specific person or audience on a topic. Trigger on "brief [person] on", "stakeholder brief", "prep a brief for", "what should I tell [audience]", or when preparing talking points or a summary tailored to leadership, engineering, CS, or cross-team PMs.

## Arguments
$ARGUMENTS: required: topic + audience (e.g., "ArcGIS upgrade for GPM", "sprint status for engineering leads")

## Your task

### Step 1: Identify the briefing parameters
From the input, determine:
- **Topic:** What the briefing is about
- **Audience:** Who will receive it (name + role if possible)
- **Context:** Is this for a meeting, email, Slack message, or slide?
- **Urgency:** Is this needed in the next 5 minutes, or can we do deep research?

### Step 2: Gather context (automatic, speed-appropriate)
**Pre-computed intelligence (check first):**
- `~/overnight-tasks/output/stakeholder-pulse/`: latest stakeholder pulse analysis (relationship context for the target audience)
- `~/overnight-tasks/output/sprint-health/`: latest sprint health snapshot (ready-to-cite numbers)
- `~/overnight-tasks/output/customer-signals/`: if customer-facing brief, check latest signals

For quick briefs (5 min):
- your Jira board (use Atlassian MCP jira_search) and epics: relevant numbers
- your Claude memory: prior context on this topic
- your docs folder: relevant notes

For deep briefs (no time pressure):
- All of the above, plus:
- your Confluence space (use Atlassian MCP confluence_search): initiative docs
- your recent OneNote notes
- your calendar: related meetings and upcoming commitments
- search Slack for [topic OR stakeholder name]: recent discussions, decisions, and context
- your decisions log (check conversation context): recent decisions relevant to this topic
- **Atlassian fallback:** MCP if available, local data if not

### Step 3: Tailor to audience
Apply stakeholder communication rules:

**Leadership (GPM, Director, CPO, VP):**
- Outcomes first, details second
- Business impact > technical detail
- Decisions needed clearly flagged with options and recommendation
- 30-second scannable format
- Include: customer impact, revenue/retention implications, timeline confidence

**Engineering leads / TPOs:**
- Technical context first
- Scope, dependencies, and constraints prominent
- Connect to sprint/PI work
- Include ticket references and PR activity
- Flag technical risks they need to plan for

**Customer Success / Support / PS:**
- Plain language only. No internal jargon
- Customer impact front and center
- Timeline and workarounds
- What they need to tell customers. Draft the exact language
- Include case references if available

**Cross-team PMs / Design:**
- Shared dependency context
- What you need from them / what they get from you
- Timeline alignment and conflict points
- Decision points with deadlines

### Step 4: Anticipate questions
For each audience type, predict the 3 most likely questions they'll ask and prepare answers:

**Leadership:** "When?" / "What's the risk?" / "What do you need from me?"
**Engineering:** "What's the scope?" / "What about [edge case]?" / "How does this interact with [other work]?"
**CS/Support:** "What do I tell customers?" / "When is it fixed?" / "Is there a workaround?"
**Cross-team:** "Does this affect my timeline?" / "What do you need from us?" / "When do you need it?"

Include these as a "Likely Questions & Answers" section.

### Step 5: Output format (match the medium)
- **Meeting prep:** Bullet points with talking points and anticipated questions
- **Email draft:** Full email with subject line, ready to send. Open as Outlook draft if requested.
- **Slack message:** Concise, threaded format with key points
- **Slide content:** Headline + 3-5 bullets per slide, speaker notes

### Step 6: Route outputs
- Save as .docx using python-docx
- If substantive, write to your docs/updates folder or Confluence via MCP

## Self-Verification (run before presenting)
Before showing the brief, verify:
- [ ] Audience is explicitly identified. Not a generic "stakeholders" brief
- [ ] Numbers are real and sourced (Jira, account data), not estimated or vague
- [ ] Tone matches the audience. Leadership gets outcomes, engineering gets details
- [ ] "What do you need from me?" is answered clearly if action is required
- [ ] Likely questions are anticipated and answered
- [ ] No jargon leaks (internal terms in customer-facing briefs, PM-speak in engineering briefs)

## Rules
- Speed matters. If asked for a "quick brief for [person]": get it done in one response.
- Match the communication style to the audience.
- Include real numbers from Jira/sprint data wherever possible.
- If you don't know something critical, say "I don't have data on X. You'll want to verify."
- After delivering, offer relevant follow-ups: "Want me to also prep for [related person]?"
- **Workflow links:** After delivering, also offer: `/update` (expand brief into a full status update), `/decision` (record any decisions surfaced during briefing prep), `/pressure-test` (stress-test the claims in the brief).
