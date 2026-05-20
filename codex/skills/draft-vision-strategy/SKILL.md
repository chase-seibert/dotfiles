---
name: draft-vision-strategy
description: Draft, critique, or revise product, team, company, or initiative strategy and vision documents. Use when Codex is asked to create a strategy memo, product vision, mission, strategic narrative, north-star story, direction-setting doc, or leadership/team alignment artifact based on Chase Seibert's "Define a Vision" and "Create a Strategy" approach.
---

# Draft Vision Strategy

## Core Model

Use this skill to turn rough initiative context into a crisp strategy, a compelling vision, or both.

When both strategy and vision are requested, draft the strategy first unless the user explicitly asks for only vision. Strategy decides what to focus on; vision makes the chosen direction vivid enough for people to understand, remember, and want to build.

- Strategy is upward-facing. It makes the case to leadership that there is a credible plan to address the decisive business challenge.
- Vision is downward-facing. It aligns and energizes the team by connecting the work to users and to concrete future outcomes.
- Mission is optional. Use it as a one-sentence end-state for what will be true if the product or initiative succeeds.

Sources that shaped this workflow:

- https://chase-seibert.github.io/blog/2022/09/27/create-a-strategy.html
- https://chase-seibert.github.io/blog/2022/02/14/define-a-vision.html

## Intake

Extract as much as possible from the user's prompt. Ask at most a few focused questions only when the missing context would make the draft misleading.

Look for:

- Initiative name, organization, and year or time horizon
- Audience: executives, board, leadership team, builders, cross-functional partners, or customers
- Parent company/org strategy, business goals, constraints, and must-haves
- Users or customers, their jobs to be done, and current pain
- Current business challenge and suspected root cause
- Evidence: metrics, user research, market context, customer feedback, cost, risk, or execution data
- Strengths to exploit, weaknesses to address, and trade-offs leaders are willing to make
- Candidate actions already under consideration
- What should be excluded: roadmap details, pixel-perfect design, deep technical specs, or unrelated goals

If the user gives sparse context, produce a clearly labeled strawman and list the assumptions to validate.

## Strategy Workflow

Draft a short strategy memo with these sections.

### 1. Title And Parent Context

Use a title like:

```markdown
[Name] Strategy [Year]
[Optional link or reference to parent strategy]
```

State the scope plainly: company, org, team, product area, or initiative.

### 2. Diagnosis

Write 2-4 sentences that identify one decisive challenge and its cause. A strong diagnosis simplifies the problem space down to the critical factor the organization must address.

The diagnosis should:

- Explain why the current state is underperforming
- Name the root cause, not just trailing indicators
- Make clear how the challenge can be overcome
- Be backed by evidence, but not phrased as a goal
- Avoid wishful language such as "we need to grow" without a plan for overcoming the obstacle

Add one tight evidence paragraph or bullet list. Prefer the single most compelling data point over a dashboard dump.

### 3. Guiding Principles

Write 2-4 principles that help the organization make trade-offs. Each principle should clarify how to choose between plausible paths.

Useful shapes:

- Exploit our [strength] by [doing X] instead of [doing Y].
- Focus resources on [area] because [reason].
- Prefer [choice] when it helps us overcome [diagnosis].

Good principles are decision rules, not slogans. They should make it easier to say no.

### 4. Coherent Actions

Write 3-5 actions that are specific, feasible, and mutually reinforcing. These are not tiny implementation tasks, but they must be concrete enough that teams can begin acting.

Actions should:

- Follow from the diagnosis and principles
- Be achievable in the relevant planning horizon
- Focus resources, attention, or sequencing
- Include measurable outcomes when useful
- Avoid pretending the roadmap is already known when the strategy is still at a high level

For org-level strategy, actions may be broad mandates. For team-level strategy, actions can be more concrete.

### 5. Trade-Offs And Open Questions

Add a brief "What we will not do" section when it clarifies focus. Add open questions only when they represent real decisions or evidence gaps.

## Vision Workflow

Draft the vision after the strategy has established focus.

### 1. Mission

Optionally start with a one-sentence mission in end-state form:

```markdown
When this succeeds, [user/customer/business] will be able to [important outcome].
```

Keep it aspirationally possible. It does not need a strict timeline.

### 2. Vision Story

Write the vision as multiple concrete end-state scenes, usually from a user's perspective. Aim for a plausible three-year horizon.

The story should:

- Show how the user accomplishes important jobs to be done
- Include enough specifics to align mental models
- Avoid prescribing exact UI, product specs, technical specs, or roadmap order
- Make the future feel tangible for builders and stakeholders
- Include business end-states or success metrics only when they strengthen the vision

Use named personas or realistic roles when helpful. Show before/after contrast through what the user can now do, not through generic claims.

### 3. Visual Aid Notes

If visuals would help an audience understand the vision, suggest rough mocks, sketches, storyboards, or a concept video. Do not imply pixel-perfect designs are required at this stage.

### 4. FAQ

Add a short FAQ for predictable stakeholder questions, especially around scope, constraints, sequencing, and what is intentionally not included. Use the FAQ to capture feedback from repeated reviews.

## Review Loop

Use feedback as part of the drafting process, not as a final approval ceremony.

For strategy:

- Get peer feedback first: are we aligned on the decisive challenge and most important actions?
- Get leadership feedback next: would they fund this initiative, and how does it relate to other strategies?
- Incorporate organizational feedback carefully: invite teams to add aligned actions without turning the strategy into a bottom-up wishlist.

For vision:

- Test with at least three audiences when possible.
- Listen for where people misunderstand the future state.
- Update the draft until executives can paraphrase it accurately and team members can explain it consistently.
- Expect meaningful revision over time as the team learns and context changes.

## Quality Bar

Before finalizing, check:

- Strategy has one primary diagnosis, not a list of unrelated goals.
- Strategy actions are coherent and plausibly executable.
- Strategy uses evidence to support the diagnosis, not to disguise a target as a plan.
- Guiding principles create real trade-offs.
- Vision is concrete, user-centered, and feasible within roughly three years.
- Vision inspires builders without sneaking in roadmap, spec, or design commitments.
- Mission, strategy, and vision do not contradict each other.
- The document is short enough that its main idea can be remembered and repeated.

## Output Templates

Use these shapes unless the user asks for a different format.

### Strategy Memo

```markdown
# [Name] Strategy [Year]

Parent context: [Link or short description, if any]

## Diagnosis

[2-4 sentences naming the decisive challenge, root cause, and how it can be overcome.]

Evidence:
- [Most compelling data point or observation]
- [Optional supporting evidence]

## Guiding Principles

1. [Decision rule]
2. [Decision rule]
3. [Decision rule]

## Actions

1. [Specific, feasible action with rationale or outcome]
2. [Specific, feasible action with rationale or outcome]
3. [Specific, feasible action with rationale or outcome]

## Trade-Offs

- We will [do/focus on X].
- We will not [do/focus on Y].

## Open Questions

- [Question to validate before finalizing]
```

### Vision Memo

```markdown
# [Name] Vision

## Mission

[One-sentence end-state, if useful.]

## Vision

[Scene 1 from a user/customer/team perspective.]

[Scene 2 showing another important job to be done or context.]

[Scene 3 showing the broader end-state, collaboration, business, or ecosystem impact.]

## Business End-States

- [Optional end-state or success metric]

## Visual Aid Ideas

- [Optional rough mock/storyboard/concept video idea]

## FAQ

**[Question]**
[Answer]
```

### Combined Strategy And Vision

When asked for both, produce:

1. Strategy
2. Mission
3. Vision
4. FAQ
5. Assumptions and open questions
