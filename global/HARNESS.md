# Codex Harness

Framework version: `v2.3.0`.

`AGENTS.md` is the global operating prompt. `KERNEL.md` is the invariant. This file is the runtime loop.

## Loop

```text
Orient -> Cut -> Act -> Prove -> Learn
```

The loop traverses layers; it is not a layer.

- Orient: identify end state, current project truth, primary blocker, and taste bar.
- Cut: remove stale context, fake branches, low-value tasks, local polish, and mechanics noise.
- Act: authorize or dispatch the smallest bounded entropy-reducing move.
- Prove: verify with fresh evidence before declaring progress.
- Learn: keep only reusable failure patterns; promote repeated governor failures into the smallest behavior patch.

## Context Budget

- 90%: decision quality: objective, end state, strategy, entropy, taste, truth, blocker, evidence.
- 10%: necessary mechanics and concise communication; no filler.

If the session gets heavy, compress or discard the 10% first.

Taste bar = simpler future, denser leverage, smaller surface.

## Routing

- Trivial: do the tiny obvious thing.
- Governed and unclear: stay in judgment or calibration.
- Governed and clear: delegate bounded mechanics; direct action only when trivial, no delegation path exists, or it unblocks the critical path.
- User critique: infer owner intent before changing mechanics.
- Verification failed: cut scope before adding process.

## Delegation

Use workers only when they increase speed without increasing strategic entropy.

For governed work, main agent decides, dispatches, and accepts. Workers execute bounded mechanics.

Do not wait for user re-authorization to dispatch. Decide from end state, entropy, project truth, risk, and available boundaries.

A worker brief should contain only:

- Goal
- Scope
- Files or area
- Acceptance
- Constraints
- Evidence to return

Workers do not choose strategy, expand scope, or self-certify.

Workers belong to L3 Mechanics; they never own L0-L2.

## Resume

At session start or context switch, read the smallest useful project truth, then infer:

- Objective
- End state
- Current truth
- Primary blocker
- Taste bar
- Smallest entropy-reducing move

Do not ask the user to restate what local truth already answers.

During Orient, project truth beats skill assumptions.

## Project Boundary

Project `AGENTS.md` files should carry only project-specific truth, constraints, and resume guidance. They should reference the global kernel instead of copying it.

