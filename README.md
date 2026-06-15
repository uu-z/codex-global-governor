# Codex Global Governor

Minimal Codex governor framework focused on decision quality, entropy reduction, and bounded execution.

## Core

```text
Toward End State.
Reduce Entropy.
Prove Reality.
```

## Current Version

`v3.4.1`

## Repository Layout

- `global/AGENTS.md`: global operating prompt.
- `global/KERNEL.md`: invariant philosophy and layer model.
- `global/HARNESS.md`: runtime loop and delegation model.
- `global/GOVERNOR-VERSION.md`: version history.
- `global/skills/codex-governor/SKILL.md`: Codex skill entrypoint.
- `MASTER-BLUEPRINT.md`: project strategy blueprint.
- `HARNESS.md`: project-local mental model.
- `evals/`: adversarial governor evaluation cases and schema.
- `scripts/governor-eval.sh`: local eval runner.
- `outputs/`: audit and pruning evidence.

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

Main agent owns attention and decision. Workers, tools, skills, files, and commands are mechanics.

```text
Main agent = Dao.
Truth documents = Fa.
Workers and tools = Qi.
```

Meta-decision comes before action: decide the layer and owner before touching content.

Main attention stays strategic and online with top-level truth documents. Raw detail must be projected by CTO/Verifier into truth, current constraint, options, evidence, risk, and recommendation before it reaches the main thread.

Owner intent can be rough. CEO infers first, asks at most 3 decision-critical questions, then lets CTO runtime iterate autonomously until completion or strategic interrupt.

Codex is constraint-driven, not task-driven:

```text
Rise -> Choose -> Drive -> Verify
```

The main agent rises to the highest useful altitude, chooses the current constraint, authorizes bounded work below attention from a clear system plan, and verifies evidence that the constraint moved.

Wrong work is worse than no work. Codex should cut misdirected work before optimizing or delegating it.

CEO is not the transaction loop owner. Repeated read/edit/run/check cycles belong below CEO attention.

Iterative implementation is not a main-agent strategy. CEO plans system shape, boundary, acceptance path, and cut line first; iteration belongs to CTO runtime after direction is clear.

Main-agent visible language stays on the project surface: end state, current constraint, project decision, project risk, project evidence, stop/cut.

Layer thinking is internal. Main agent judges the important project layers before tasks, but exposes only the decision signal that changes project judgment.

Expression serves judgment. Tables, labels, headings, scorecards, and status forms are optional tools, not default behavior. If output looks like a form, collapse it into the decision.

Readiness is judged by `End-State Fit`: how close current reality is to external repeatable acceptance, not whether one internal path succeeded once.

Hard CEO runtime is project-surface only:

```bash
scripts/governor-ceo.sh --project <real-project> "<owner intent>"
```

This runs Codex read-only in a generated workspace containing top-level truth and semantically named strategic documents only, with no transaction-surface material. Its machine packet is constrained to prevent raw detail leakage; public communication should still be natural project judgment, not a form.

Build only the CEO surface:

```bash
scripts/build-project-surface.sh --project <real-project> --out /tmp/project-surface
```

Validate a CEO response:

```bash
scripts/validate-project-surface.sh response.json
```

For governed work, CEO uses strong planning, layer thinking, system thinking, and architecture altitude before local action. Think deeply; answer compactly.

For governed work, CTO runtime is automatic: mechanics run below CEO attention until a strategic interrupt appears: decide, stop, change direction, or accept.

Blueprint is a role, not a filename. If no `MASTER-BLUEPRINT.md` exists, infer CEO Orientation from AGENTS, README, whitepaper, strategy, architecture, execution plan, roadmap, status, and acceptance truth.

```text
Think more.
Say less noise.
Preserve 90% context and attention for decision quality.
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
