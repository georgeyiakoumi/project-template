# ux-process.md — UX Process Reference

Reference this file when working upstream of high-fidelity design: research, strategy, personas, flows, IA, or testing.
These are the activities that happen before pixels — and the ones that make pixels defensible.

---

## Artifact storage reference

| Artifact | Tool | Notes |
|---|---|---|
| Research findings, insight statements, affinity maps | **Notion** | One page per research round, linked from the master plan |
| UX strategy, experience principles, opportunity maps | **Notion** | Stored in the master plan document under Goals / Design principles |
| User personas | **Notion** | One page per persona, linked from the master plan |
| User stories | **Notion → Linear** | Written in Notion first; each story then mirrored as a Linear issue |
| Information architecture (site maps) | **Excalidraw** | Generated via MCP; link embedded in the relevant Notion page |
| User flows | **Excalidraw** | Generated via MCP; one board per flow, link embedded in Notion |
| Usability test plans + findings | **Notion** | One page per test round, findings logged with severity ratings |

---

## UX Research

**The principle:** Design decisions should be grounded in observed user behaviour, not assumed preferences. Research de-risks decisions by surfacing what you don't know before it's too late to change.

**Research methods by question type:**

| Question | Method |
|---|---|
| What do users do? | Analytics review, session recordings, diary studies |
| Why do users do it? | User interviews, contextual enquiry |
| Can users complete a task? | Usability testing (moderated or unmoderated) |
| What do users prefer? | Preference testing, surveys |
| How does this perform? | A/B testing, multivariate testing |

**Research output formats:**
- **Insight statement:** What we observed, what it means, what we should do about it
- **Affinity map:** Clustered observations from qualitative sessions
- **Research report:** Methodology, participants, key findings, recommendations

**Insight statement format:**
```
Observation: [What users did or said]
Meaning:     [What this reveals about their mental model or need]
Implication: [What design should consider or change as a result]
```

**Questions to ask before any research:**
- What decision will this research inform?
- What do we already know? What's the gap?
- Who are the right participants — and how many do we need?
- What's the minimum viable research to reduce risk on this decision?

**5-user rule:** For qualitative usability testing, 5 participants reveal ~85% of usability problems. More users = diminishing returns for discovery; more rounds of testing > more participants per round.

**Where it lives:** Notion — one page per research round, structured as: methodology → participants → key findings (as insight statements) → recommendations. Link the page from the master plan.

---

## UX Strategy

**The principle:** UX strategy aligns the experience with business outcomes and user needs over time. Without it, design becomes a series of disconnected feature requests.

**The three questions UX strategy answers:**
1. Who are we designing for, and what do they actually need?
2. What experience would genuinely differentiate us?
3. How do we sequence and prioritise the work to get there?

**Strategic framing format:**
```
User goal:    [What the user is trying to accomplish]
Business goal: [What the business needs this to achieve]
Opportunity:  [Where the user goal and business goal align — this is the design space]
Success looks like: [How we'd know we got it right]
```

**Common strategy outputs:**
- Experience principles (not "be simple" — "make the first step feel effortless even if the task is complex")
- Jobs To Be Done framework: "When I [situation], I want to [motivation], so I can [expected outcome]"
- Opportunity maps: user needs plotted against how well the current product serves them

**Questions to ask:**
- If we built this perfectly, what would change for the user?
- What's the one experience we want users to describe when they recommend this product?
- Are we solving a real problem or building a feature because someone asked for it?

**Where it lives:** Notion — strategy outputs live inside the master plan document (Goals, Design principles, and Milestones sections). Do not create a separate document; keep it co-located with the plan so it's referenced, not forgotten.

---

## User Personas

**The principle:** Personas are decision-making tools, not deliverables. A good persona makes it faster to align a team around a specific user's needs. A bad persona is a stock photo with a name and a list of demographics that nobody uses.

**What makes a persona useful:**
- Based on real research (interviews, analytics, observations) — not invented
- Focused on goals, behaviours, and frustrations — not demographics
- Small in number: 2–4 primary personas per product; more dilutes focus
- Used actively in design reviews ("Would Jamie actually encounter this scenario?")

**Persona structure:**
```
Name + role:      [First name, job or life context]
Core goal:        [What they're ultimately trying to accomplish — in one sentence]
Key behaviours:   [How they currently handle this problem — tools, workarounds, habits]
Frustrations:     [What breaks down for them today]
Success looks like: [What good looks like from their perspective]
Quote:            [A representative thing they said in research — real or composite]
```

**Anti-patterns to avoid:**
- Personas built without user research (they just reflect internal assumptions)
- More than 4–5 primary personas (team loses focus)
- Demographic-heavy personas that focus on age/gender/salary instead of behaviour
- Personas that live in a deck and are never referenced again

**Where it lives:** Notion — one page per persona using the structure above. Link all persona pages from the master plan. Reference persona names explicitly in Linear issue descriptions and design reviews.

---

## User Stories

**The principle:** User stories keep development focused on user outcomes rather than system features. They force the team to articulate who wants something and why, not just what to build.

**Format:**
```
As a [specific user type],
I want to [specific action or capability],
So that [the outcome or value this creates for them].
```

**Acceptance criteria format (to pair with each story):**
```
Given [context or starting condition],
When [the user takes this action],
Then [the expected outcome].
```

**Good user stories:**
- Specific about the user type — not "a user", but "an admin managing multiple accounts"
- Focused on the outcome, not the implementation ("so I can see my usage at a glance" not "so there is a chart on the dashboard")
- Small enough to be completed in a sprint — split epics into stories

**Epic → Story → Task hierarchy:**
```
Epic:  Users can manage their subscription
Story: As a paying user, I want to upgrade my plan, so that I can access premium features
Task:  Design upgrade modal / Update billing API / Write confirmation email
```

**Where it lives:** Notion first, then mirrored to Linear.

1. Write all stories in a Notion page titled `[Project Name] — User Stories`, grouped by epic
2. Include acceptance criteria alongside each story in Notion
3. Once reviewed, create a corresponding Linear issue for each story using the issue format in `project-setup.md`
4. Paste the Notion story URL into the Linear issue description so both stay linked
5. Acceptance criteria in Notion become the Linear issue's definition of done — do not rewrite them, reference them

---

## Layouts & Information Architecture (IA)

**The principle:** IA defines how content and functionality is structured, labelled, and navigated before any visual design is applied. Good IA makes a product feel intuitive; bad IA makes users feel lost even if the UI is beautiful.

**IA methods:**

| Method | What it reveals |
|---|---|
| Card sorting (open) | How users naturally group and label content |
| Card sorting (closed) | Whether your proposed structure makes sense to users |
| Tree testing | Whether users can find things in your proposed navigation |
| First-click testing | Whether users start in the right place for a given task |

**Site map structure format:**
```
Level 1: Top-level navigation (Home / Product / Pricing / About)
Level 2: Section pages (Product → Features / Integrations / Security)
Level 3: Detail pages (Features → Analytics / Reporting / Alerts)
```

**IA principles:**
- **Findability** — can users locate what they need without help?
- **Clarity** — do navigation labels mean what users expect them to mean?
- **Depth vs breadth trade-off** — fewer top-level items (broad) vs more top-level items with less depth (flat)
- **Consistent placement** — things that appear in multiple places should appear in the same place every time

**Questions to ask:**
- Where would a first-time user expect to find X?
- Are navigation labels based on user language or internal company language?
- If the product doubled in size, would this structure still hold?

**Where it lives:** Excalidraw — generated via MCP using the site map format above. Use one board per product area if the IA is large. Once generated, embed the Excalidraw link in the relevant Notion page (typically under the master plan's Scope section). When updating the IA, update the Excalidraw board and note the change as a comment on the relevant Linear issue.

---

## User Flows

**The principle:** User flows map the steps a user takes to complete a specific task — from entry point to success state. They expose missing steps, dead ends, and error states before any screens are designed.

**Flow notation:**
```
[Rounded rect] = screen or page
[Diamond]      = decision point (yes/no, logged in/out)
[Arrow]        = user action or system transition
[Rectangle]    = system action (email sent, data saved)
```

**What a complete flow includes:**
- Entry point (how does the user arrive here?)
- Happy path (the ideal route to task completion)
- Error states (what happens if something goes wrong?)
- Edge cases (what if the user is a guest? What if the account is expired?)
- Exit points (where does the user end up after completing the task?)

**User flow checklist:**
- [ ] Entry points defined (direct link, email, navigation, search)
- [ ] Happy path clear with no unnecessary steps
- [ ] All decision points accounted for
- [ ] Error states designed (not just happy path)
- [ ] Success state defined (what does the user see when done?)

**Questions to ask:**
- How many steps does this task take? Could any be removed or combined?
- What happens if the user makes a mistake at each step?
- Is there a way for the user to get irreversibly stuck?

**Where it lives:** Excalidraw — generated via MCP, one board per distinct user flow. Name boards clearly: `[Project] — [Flow name] flow` (e.g. `Acme — Onboarding flow`). Embed the link in the corresponding Notion user story page and in the relevant Linear issue description. If a flow changes materially after being drawn, redraw it — do not annotate over a stale version.

---

## User Testing

**The principle:** Usability testing replaces assumptions with observations. It is the single highest-ROI activity in UX — catching problems before development is orders of magnitude cheaper than fixing them after launch.

**Testing types:**

| Type | When to use | Fidelity needed |
|---|---|---|
| Concept testing | Early — validate the problem/solution | Sketches, paper prototypes |
| Task-based usability | Mid — can users complete key tasks? | Clickable prototype |
| Comparative testing | Mid — which version performs better? | Two parallel prototypes |
| Regression testing | Post-launch — did a change break anything? | Live product |

**Session structure (moderated test):**
1. Welcome + briefing (5 min) — explain the purpose, reassure them you're testing the design not them
2. Warm-up questions (5 min) — understand their context and familiarity
3. Tasks (20–30 min) — give specific tasks, ask them to think aloud, do not help
4. Debrief (10 min) — ask overall impressions, anything confusing, anything missing

**Think-aloud prompt:** "Please say out loud what you're thinking as you go — there are no wrong answers."

**Finding severity rating:**
```
Critical:   Prevents task completion — fix immediately
Major:      Causes significant difficulty or errors — fix before launch
Minor:      Causes mild confusion — fix when possible
Enhancement: Positive feedback or opportunity — consider for future
```

**Analysis format:**
```
Task:      [What the user was asked to do]
Observed:  [What they actually did]
Finding:   [The underlying usability issue]
Severity:  [Critical / Major / Minor / Enhancement]
Recommendation: [Specific design change to address it]
```

**Questions to ask after testing:**
- Were there tasks that multiple participants failed or struggled with?
- Were there moments of visible hesitation or confusion?
- Did participants verbalise assumptions we didn't anticipate?
- What surprised us?

**Where it lives:** Notion — one page per test round, structured as: test plan → participants → tasks → findings (using the analysis format above with severity ratings) → recommendations. Link findings to the relevant Linear issues so fixes are tracked. If a finding results in a scope change, update the master plan first.
