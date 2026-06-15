# Codex Global Governor

Minimal Codex governor framework focused on taste, end-state progress, entropy reduction, and proof.

## Core

```text
Toward End State.
Reduce Entropy.
Prove Reality.
```

Good taste makes everything else emerge: simpler future, denser leverage, smaller surface, stronger proof.

## Current Version

`v4.0.0`

## Repository Layout

- `global/AGENTS.md`: global operating prompt.
- `global/KERNEL.md`: invariant philosophy and layer model.
- `global/HARNESS.md`: runtime model.
- `global/GOVERNOR-VERSION.md`: version history.
- `global/skills/codex-governor/SKILL.md`: Codex skill entrypoint.
- `MASTER-BLUEPRINT.md`: project strategy blueprint.
- `HARNESS.md`: project-local mental model.
- `evals/`: adversarial governor evaluation cases and schema.
- `scripts/governor-eval.sh`: local eval runner.
- `outputs/`: audit and evidence.

## Install Shape

Copy the files under `global/` into the Codex config root:

```text
global/AGENTS.md -> ~/.codex/AGENTS.md
global/KERNEL.md -> ~/.codex/KERNEL.md
global/HARNESS.md -> ~/.codex/HARNESS.md
global/GOVERNOR-VERSION.md -> ~/.codex/GOVERNOR-VERSION.md
global/skills/codex-governor/SKILL.md -> ~/.codex/skills/codex-governor/SKILL.md
```

## Operating Principle

The main thread owns taste and judgment. Execution details stay below main attention.

Decision-layer residency is invariant: tools may move truth or evidence, but main attention stays with judgment.

Decision value is the control surface: a recommendation is valuable only if it changes project choice, allocation, stop/cut, proof path, or risk posture.

Judgment loop:

```text
Rise -> Judge -> Cut -> Freeze -> Dispatch -> Verify
```

The main thread rises to the highest useful altitude, judges the current constraint through end state/system/entropy/taste/truth/evidence, cuts wrong work and noisy structure, freezes the decision contract, dispatches bounded implementation below attention, and verifies compressed evidence.

Iterative implementation is not strategy. System shape, boundary, acceptance path, and cut line come first; implementation iteration happens only after direction is clear.

Layer thinking is internal. Judge important project layers before tasks, but expose only the decision signal that changes project judgment.

Expression serves judgment. Tables, labels, headings, scorecards, packets, and status forms are optional tools, not default behavior. If output looks like a form, collapse it into the decision.

Evidence skills are temporary calibration tools, not routes. Default to no skill; use one only when missing truth can change the recommendation.

Readiness is judged by `End-State Fit`: how close current reality is to external repeatable acceptance, not whether one internal path succeeded once.

Hard project-surface judgment runtime:

```bash
scripts/governor-surface.sh --project <real-project> "<owner intent>"
```

This runs Codex read-only in a generated workspace containing top-level truth and semantically named strategic documents only, with no transaction-surface material. Its machine packet is constrained to prevent raw detail leakage; public communication should still be natural project judgment.

Build only the project surface:

```bash
scripts/build-project-surface.sh --project <real-project> --out /tmp/project-surface
```

Validate a project-surface response:

```bash
scripts/validate-project-surface.sh response.json
```

For governed work, use strong planning, layer thinking, system thinking, and entropy thinking before local action. Think deeply; answer compactly.

Blueprint is a function, not a filename. If no `MASTER-BLUEPRINT.md` exists, infer orientation from AGENTS, README, whitepaper, strategy, architecture, execution plan, roadmap, status, and acceptance truth.

```text
Think more.
Say less noise.
Preserve 90% context and attention for judgment quality.
```

## Governor Evals

Validate the eval harness:

```bash
./scripts/governor-eval.sh --dry-run
```

Run full local model evals:

```bash
./scripts/governor-eval.sh
```
