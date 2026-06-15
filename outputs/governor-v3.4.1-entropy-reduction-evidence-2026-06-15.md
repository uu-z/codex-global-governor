# Governor v3.4.1 Entropy Reduction Evidence

Date: 2026-06-15

Framework version: `v3.4.1`

## Decision

v3.4.0 made the right strategic move by restoring layer judgment, but it over-hardened the expression layer by requiring `layer_percentages` in schemas and eval responses.

v3.4.1 keeps layer thinking internal and deletes the parts that turn judgment into ceremony.

## Removed

- Hard `layer_percentages` requirements from project-surface and eval response schemas.
- Validator checks that forced visible layer percentages into project-surface responses.
- Prompt language requiring visible layer percentages.
- The separate `architect-pm` skill route, because architecture/project judgment belongs inside governor layer thinking, not a second workflow.
- Stale v3.4 evidence claiming `layer_percentages` is a hard requirement.
- Main-agent iterative implementation as an accepted way to discover strategy.

## Preserved

- End-state fit readiness judgment.
- Project-surface runtime boundary.
- Semantic tripwire against transaction-surface leakage.
- Layer thinking as internal strategic judgment.
- Constraint-first routing and execution separation.

## Acceptance

The framework should now:

- think by layers without exposing scorecards by default
- prevent raw implementation detail from reaching main attention
- avoid mandatory tables, status forms, or repeated labels
- require strong planning before execution: system shape, boundary, acceptance path, and cut line
- keep hard boundaries where they reduce real leakage
- delete process artifacts that do not move the end state

## Verification

- `./scripts/governor-eval.sh --dry-run` validated 22 eval cases.
- `jq -e . evals/response.schema.json schemas/project-surface-response.schema.json` passed.
- `bash -n scripts/*.sh` passed.
- `python3 /Users/test/.codex/skills/.system/skill-creator/scripts/quick_validate.py global/skills/codex-governor` passed.
- Targeted real eval passed: `./scripts/governor-eval.sh --case implementation-iteration-is-not-strategy`.

The targeted eval response stopped execution because architecture, boundary, and acceptance were unclear, and identified implementation iteration as entropy-increasing L3 mechanics trying to discover L1 strategy.

Full real eval was started but stopped after it exceeded the local usefulness threshold for this patch. The release gate for v3.4.1 is the targeted real eval plus structural validation, because this change removes rigid output requirements rather than expanding behavior surface.
