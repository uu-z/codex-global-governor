# Governor v4/v5 Research Brief

Date: 2026-06-15

Current stable baseline: `v3.4.3`

## Decision

Do not continue v3.4.x prompt polishing.

The next valuable move is v4 research and design. v5 should stay as a research horizon until v4 proves that decision-layer output can reliably change project choices.

## Current Constraint

v3.4.3 keeps the main thread out of execution loops.

It does not yet prove that the main thread outputs valuable decisions. A model can stay in the decision layer and still produce low-value process language, labels, or correct-but-useless summaries.

The new constraint is decision value:

```text
A decision recommendation is valuable only if it changes project choice, allocation, stop/cut, proof path, or risk posture.
```

If it does not change one of those, it is narration.

## v4 Candidate: Decision Value Surface

v4 should make recommendation value the control surface.

The main thread should output one high-value project recommendation, not a workflow recap.

Required decision signal:

```text
Choose this.
Cut that.
Because this is the current system constraint.
Proof must show this.
Dispatch only after this boundary is frozen.
```

v4 should force every governed response through five private gates:

| Gate | Question | Bad Output |
|---|---|---|
| Choice | What should change now? | "Here are considerations." |
| Cut | What should stop or be removed? | "Continue improving everything." |
| System | Why is this the system constraint? | "This task is important." |
| Entropy | Why is this simpler than alternatives? | "Add process to manage process." |
| Proof | What evidence would change the decision? | "Looks good / likely works." |

Visible output should remain compact. Tables are optional, not mandatory.

## v4 Skill Surface

v4 should introduce skills, but not "more skills" as a default.

The right move is a small evidence-skill surface:

```text
decision first
targeted research second
implementation last
```

Skills exist to improve decision quality. They should not own direction, output format, or project priority.

Useful v4 skills:

| Skill Type | Purpose | When To Use | Output |
|---|---|---|---|
| Targeted Research | Find external truth, precedents, constraints, and better options. | When decision quality is limited by missing outside evidence. | Decision-changing facts, options, risks, citations. |
| Architecture Precedent | Find mature patterns instead of inventing. | When a design choice risks wheel-building. | Existing solutions, tradeoffs, adoption reason. |
| Project Truth Audit | Locate the real project truth and current constraint. | At session start or after context drift. | Top truth, current constraint, missing truth. |
| Evidence Verification | Check whether claimed progress is real. | Before completion, launch, or accepting implementation. | Pass/fail evidence and unresolved risk. |
| Option Stress Test | Attack the recommended choice. | For irreversible or expensive decisions. | Failure modes, kill criteria, alternative if wrong. |

Default v4 should not load all skills.

It should choose at most one evidence skill unless the decision is high-stakes and multiple independent truth gaps exist.

## Skill Gate

A skill is allowed only if it answers one of these:

- What truth is missing?
- What option are we failing to consider?
- What mature solution should replace custom work?
- What evidence would prove or kill the recommendation?
- What risk changes the decision?

If a skill does not change the recommendation, it is noise.

## v5 Candidate: Strategic Search Surface

v5 should not be implemented yet.

v5 is for high-stakes choices where one recommendation is not enough. It should generate competing strategic options and select one.

Useful only when:

- architecture direction is irreversible
- product positioning is unclear
- multiple plausible end states compete
- implementation cost is high
- wrong choice is expensive

v5 decision pattern:

```text
Option A / Option B / Option C
Compare end-state fit, entropy cost, proof strength, failure cost.
Choose one.
Kill the rest.
```

v5 risk: it can easily become analysis theater. It must stay dormant until v4 proves decision value on ordinary governed work.

## Architecture Comparison

| Architecture | Score | Why |
|---|---:|---|
| Keep v3.4.3 only | 75 | Good boundary, weak decision-value guarantee. |
| v3.4.4 prompt patch | 60 | Local patch; easy to become another rule. |
| v4 Decision Value + Evidence Skills | 90 | Directly targets useful recommendations and gives them better truth. |
| v5 Strategic Search Surface | 92 potential / 55 now | Powerful for major choices, too complex before v4 is proven. |

## Recommendation

Build v4 next.

Do not implement v5 yet.

Do not add more roles, templates, skills, or ceremonies.

v4 should be a small harness change:

- Add "Decision Value" as a first-class quality gate.
- Add a small evidence-skill surface, especially targeted research.
- Keep `Rise -> Judge -> Cut -> Freeze -> Dispatch -> Verify`.
- Require recommendation to change choice, allocation, stop/cut, proof path, or risk posture.
- Add evals that fail process-sounding but non-decisive answers.
- Keep hard boundary and subagent dispatch from v3.4.3.
- Allow at most one targeted evidence skill by default.

## v4 Acceptance

v4 is real only if adversarial prompts prove:

- It rejects process recap when asked for strategy.
- It identifies a system constraint, not a loud local task.
- It recommends a concrete choice and cut.
- It states what evidence would change the decision.
- It uses targeted research when the decision is truth-limited.
- It refuses skill use when the skill would not change the recommendation.
- It dispatches only after decision boundary is frozen.
- It keeps visible output compact and project-level.

## Stop List

- Do not ship v4 as a larger prompt.
- Do not introduce standing roles.
- Do not make a mandatory decision template.
- Do not turn v4 into a skill router.
- Do not run research when project truth already decides the constraint.
- Do not use v5 strategic search for ordinary tasks.
- Do not mistake "being at decision altitude" for "making a valuable decision."

## Next Move

Design v4 as a minimal kernel change plus eval coverage.

Only after v4 evals prove decision value should global behavior truth move from `v3.4.3` to `v4.0.0`.
