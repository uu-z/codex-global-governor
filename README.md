# Codex Global Governor

Minimal Codex governor framework focused on decision quality, entropy reduction, and bounded execution.

## Core

```text
Toward End State.
Reduce Entropy.
Prove Reality.
```

## Current Version

`v2.3.0`

## Repository Layout

- `global/AGENTS.md`: global operating prompt.
- `global/KERNEL.md`: invariant philosophy and layer model.
- `global/HARNESS.md`: runtime loop and delegation model.
- `global/GOVERNOR-VERSION.md`: version history.
- `global/skills/codex-governor/SKILL.md`: Codex skill entrypoint.
- `MASTER-BLUEPRINT.md`: project strategy blueprint.
- `HARNESS.md`: project-local mental model.
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
Think more.
Say less noise.
Preserve 90% context and attention for decision quality.
```

