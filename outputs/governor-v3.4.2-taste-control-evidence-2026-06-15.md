# Governor v3.4.2 Taste Control Evidence

Date: 2026-06-15

Framework version: `v3.4.2`

## Decision

The framework should not depend on organization metaphors or identity games. Those words were creating a second surface that could become ceremony.

v3.4.2 makes taste the control surface:

```text
simpler future
denser leverage
smaller surface
stronger proof
```

## Removed From Current Behavior

- Old organization-metaphor vocabulary.
- Old execution-identity vocabulary.
- Old philosophy-triad vocabulary.
- Identity-game framing and standing-identity instructions.
- The old hard-runtime entrypoint name.

## Preserved

- End-state fit.
- Layer and system thinking.
- Strong planning before execution.
- Project-surface hard boundary.
- Transaction-surface leakage checks.
- Evidence before completion.
- Anti-scorecard and anti-template posture.

## Acceptance

The current framework should read as:

```text
main attention controls taste and judgment
truth anchors reality
execution stays below attention
evidence proves movement
```

It should not read as a company org chart, identity game, or coordination framework.

## Verification

- `./scripts/governor-eval.sh --dry-run` validated 22 eval cases.
- `jq -e . evals/response.schema.json schemas/project-surface-response.schema.json` passed.
- `bash -n scripts/*.sh` passed.
- `python3 /Users/test/.codex/skills/.system/skill-creator/scripts/quick_validate.py global/skills/codex-governor` passed.
- `git diff --check` passed.
- Targeted real eval passed: `./scripts/governor-eval.sh --case coordination-theater-sprawl`.
- Targeted real eval passed: `./scripts/governor-eval.sh --case implementation-iteration-is-not-strategy`.

The targeted evals prove the core v3.4.2 movement: cut coordination theater and reject implementation iteration as strategy.
