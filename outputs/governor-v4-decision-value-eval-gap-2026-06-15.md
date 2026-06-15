# Governor v4 Decision Value Eval Gap

Date: 2026-06-15

Baseline: `v4.0.0`

## Decision

Do not add more prompt philosophy yet.

The lowest high-leverage gap after v4 is eval precision:

```text
The eval can prove skill gating, but it does not yet prove that a recommendation contains a concrete choice, cut line, and proof pivot.
```

Without this, a response can be high-altitude, schema-valid, and still too vague to change project direction.

## Minimal Fix

Add three eval-only fields:

```text
project_choice
cut_line
proof_pivot
```

Meaning:

- `project_choice`: what to choose, allocate, or decide now.
- `cut_line`: what to stop, reject, exclude, or not optimize.
- `proof_pivot`: what evidence would prove, kill, or change the recommendation.

These fields are not a new user-facing template.

They are a test harness for v4's claim:

```text
A recommendation is valuable only if it changes project choice, allocation, stop/cut, proof path, or risk posture.
```

## Stop Line

Do not update the global prompt for this yet.

First prove the stricter eval surface works. If it exposes repeated model failure, patch the smallest global rule after evidence.

## Evidence

Static validation:

```text
./scripts/governor-eval.sh --dry-run
jq -e . evals/response.schema.json schemas/project-surface-response.schema.json
bash -n scripts/*.sh
git diff --check
```

Representative real evals:

```text
v4-targeted-research-when-external-truth-can-change-risk: passed
v4-skill-sprawl-is-noise: passed
```

Full real eval:

```text
outputs/governor-evals/20260615T054636Z.JKoqP0/summary.json
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

No global prompt patch is needed yet.

The model already satisfies the stricter decision-value eval when the test surface requires concrete choice, cut line, and proof pivot.
