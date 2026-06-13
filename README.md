# Codex Global Governor

Minimal Codex governor framework focused on decision quality, entropy reduction, and bounded execution.

## Core

```text
Toward End State.
Reduce Entropy.
Prove Reality.
```

## Current Version

`v2.6.0`

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

Main attention stays strategic and online with top-level truth documents. Raw detail must be projected by CTO/Verifier into truth, blocker, options, evidence, risk, and recommendation before it reaches the main thread.

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
