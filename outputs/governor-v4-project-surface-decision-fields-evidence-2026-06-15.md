# Governor v4 Project Surface Decision Fields Evidence

Date: 2026-06-15

Baseline: `v4.0.0`

## Decision

Align the hard project-surface runtime with v4 decision-value evals.

The gap:

```text
evals require project_choice / cut_line / proof_pivot,
but the hard project-surface schema still accepted only the older project_decision shape.
```

That split could let real governed judgment bypass the v4 decision-value gate.

## What Changed

Project-surface response schema and validator now require:

```text
project_choice
cut_line
proof_pivot
```

`scripts/governor-surface.sh` prompts for the same fields.

`scripts/build-project-surface.sh` includes the same concepts in the generated project surface.

## Meaning

- `project_choice`: what to choose, allocate, or decide now.
- `cut_line`: what to stop, reject, exclude, or not optimize.
- `proof_pivot`: what evidence would prove, kill, or change the recommendation.

This is runtime alignment, not a new global prompt layer.

## Evidence

Static validation:

```text
./scripts/governor-eval.sh --dry-run
jq -e . schemas/project-surface-response.schema.json evals/response.schema.json
bash -n scripts/*.sh
git diff --check
python3 /Users/test/.codex/skills/.system/skill-creator/scripts/quick_validate.py global/skills/codex-governor
```

Validator shape checks:

```text
valid v4 project-surface response: accepted
old project-surface response without project_choice / cut_line / proof_pivot: rejected
```

Real hard-boundary project-surface run:

```text
./scripts/governor-surface.sh --project . -o /tmp/codex-governor-v4-surface-response.json "New session. What should this governor project do next?"
```

Result:

```text
passed schema and project-surface validator
```

The response included `project_choice`, `cut_line`, and `proof_pivot`.

Full governor eval after runtime alignment:

```text
outputs/governor-evals/20260615T061508Z.CZrC8C/summary.json
```

Result:

```json
{
  "total": 29,
  "passed": 29,
  "failed": 0,
  "failures": []
}
```

## Result

The hard project-surface runtime now enforces the same decision-value fields as the v4 eval surface.

No global prompt patch was required.
