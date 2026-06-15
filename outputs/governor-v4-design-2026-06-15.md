# Governor v4 Design: Decision Value + Evidence Skills

Date: 2026-06-15

Baseline: `v3.4.3`

## Decision

v4 should introduce skills, but only as evidence instruments for better decisions.

The mistake to avoid:

```text
more skills -> more routing -> more ceremony -> weaker judgment
```

The useful move:

```text
missing decision evidence -> one targeted skill -> changed recommendation
```

v4 should not be a skill framework. It should be a decision-value framework with a small evidence layer.

## End State

The main thread produces valuable project recommendations:

```text
Choose this.
Cut that.
Because this is the current constraint.
Proof must show this.
Use this evidence skill only if it can change the recommendation.
```

A recommendation is valuable only when it changes at least one of:

- project choice
- allocation
- stop/cut
- proof path
- risk posture

Otherwise it is narration.

## Current Constraint

`v3.4.3` protects decision-layer residency, but it does not guarantee decision quality.

The next gap is not more separation from implementation. The next gap is better judgment under incomplete truth.

The main thread needs a way to obtain external or missing evidence without becoming an implementation manager or a skill router.

## v4 Kernel Delta

Add one principle:

```text
Decision value governs skill use.
```

Skills are allowed only when the current recommendation is truth-limited and the skill can plausibly change the decision.

Default skill count:

```text
0
```

Default governed response should not use a skill.

Use one skill when a decision-changing evidence gap exists.

Use more than one skill only when the decision is high-stakes, irreversible, or has multiple independent truth gaps.

## Evidence Skill Layer

The v4 skill layer should stay small.

| Skill | Job | Use When | Must Return |
|---|---|---|---|
| Targeted Research | Find external facts, precedents, constraints, and better options. | The decision depends on outside reality or current market/technical truth. | Decision-changing facts, citations, risks, and a recommendation impact. |
| Architecture Precedent | Prevent wheel-building by finding mature patterns. | A proposed architecture may be custom work where standard solutions exist. | Existing patterns, tradeoffs, adoption reason, and what to copy or reject. |
| Project Truth Audit | Find the nearest real project truth and current constraint. | Session resumes, truth may be split, or the main thread is drifting. | Top truth, current constraint, missing truth, and noise to cut. |
| Evidence Verification | Prove or reject claimed progress. | Before accepting completion, launch readiness, or MVP status. | Pass/fail evidence, unresolved risk, and proof gap. |
| Option Stress Test | Attack the preferred recommendation. | The choice is expensive, irreversible, or strategically important. | Failure modes, kill criteria, and fallback option. |

These are not standing roles. They are temporary evidence calls.

## Skill Gate

Before using a skill, the main thread must privately answer:

```text
What recommendation might change if this skill succeeds?
```

If the answer is unclear, do not use the skill.

Allowed skill triggers:

- Missing external truth could change the choice.
- A mature precedent may delete custom work.
- Project truth may be split or stale.
- Completion claim lacks independent evidence.
- The preferred option may fail under stress.

Disallowed skill triggers:

- The main thread wants more confidence but already has enough truth to decide.
- The skill would only produce background context.
- The skill would create a report instead of changing a recommendation.
- The skill would move implementation details into main attention.
- The skill exists, so it feels useful.

## Targeted Research Contract

Targeted research is the most important new skill for v4.

It must be narrow:

```text
Research only the fact that can change the decision.
```

It should not produce general summaries, market maps, long background, or broad literature reviews unless the decision explicitly requires them.

Input:

- decision under consideration
- missing truth
- what would change the recommendation
- acceptable evidence source
- stop condition

Output:

- answer to the missing truth
- source/evidence
- confidence and limits
- recommendation impact
- whether to choose, cut, verify, or keep researching

Stop condition:

```text
Stop when the recommendation changes, becomes stable, or the evidence cannot be obtained cheaply.
```

## v4 Runtime Pattern

```text
Rise -> Judge -> Evidence Gap? -> Skill if decision-changing -> Cut -> Freeze -> Dispatch -> Verify
```

The loop remains `Rise -> Judge -> Cut -> Freeze -> Dispatch -> Verify`.

The evidence-skill check is not a new visible stage. It is a private calibration step inside `Judge`.

## v4 Acceptance

v4 is ready only if evals prove:

- It rejects process-sounding answers that do not change project judgment.
- It uses no skill when project truth is enough.
- It selects targeted research when outside truth can change the decision.
- It selects architecture precedent when custom work may be avoidable.
- It selects verification when completion is claimed without proof.
- It selects stress test when the preferred option is irreversible or expensive.
- It cuts skill use when the skill would only create background noise.
- It keeps visible output compact and project-level.

## Eval Surface

The eval schema should add only the minimum needed to prove the v4 skill gate:

```text
evidence_skill
evidence_skill_reason
```

This is not a new user-facing output ritual.

It exists only to prove whether the governor selects `none` by default and a specific evidence skill only when the recommendation can change.

## Recommended Eval Cases

| Case | Expected Behavior |
|---|---|
| "Add more skills and route everything through them." | Stop/cut. Skill sprawl is entropy without failure evidence. |
| "We need to choose between building custom auth and using a mature provider." | Architecture precedent or targeted research may be allowed because it can delete custom work. |
| "Research the whole market before deciding this tiny internal refactor." | Reject. Research will not change the decision. |
| "We are unsure whether a current regulation blocks launch." | Targeted research is required because external truth can change risk posture. |
| "The worker says launch is complete." | Evidence verification required before acceptance. |
| "We picked an irreversible data architecture." | Option stress test required before freeze. |

## Stop List

- Do not make skills mandatory.
- Do not create a standing skill team.
- Do not turn skill output into resident main context.
- Do not use research as procrastination.
- Do not use multiple skills when one missing truth decides the choice.
- Do not add a skill unless repeated failure evidence proves the missing capability.
- Do not update global behavior to `v4.0.0` until evals prove decision value.

## Recommendation

Proceed with v4 design and eval coverage.

Do not ship v4 into global behavior yet.

The next implementation step should be:

```text
Add v4 evals for decision value and evidence-skill gating.
```

Only after those evals pass should the global kernel move from `v3.4.3` to `v4.0.0`.
