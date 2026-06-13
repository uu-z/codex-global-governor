# Governor v3 LLM Eval Evidence

Date: 2026-06-13

Framework version: `v3.0.1`

## Run

Command:

```bash
./scripts/governor-eval.sh
```

Run directory:

```text
outputs/governor-evals/20260613T154726Z/
```

Note: `outputs/governor-evals/` is ignored because it contains raw model responses and events. This file records the committed evidence summary.

## Result

```json
{
  "total": 17,
  "passed": 17,
  "failed": 0,
  "failures": []
}
```

## Coverage

The run covered:

- prompt bloat rejection
- main-agent implementation drift
- local-correct/global-wrong work
- truth split prevention
- worker sprawl prevention
- evidence-before-completion
- resume focus
- bounded mechanics
- Dao/Fa/Qi boundary
- meta-decision before action
- system lens village trap
- rough-intent autonomous delivery
- detail flood resistance
- constraint-before-continuation
- small bug constraint test
- compressed detail gate
- efficient wrong-work prevention

## Judgment

The v3 governor passed the current first-move adversarial LLM eval suite.

This proves initial routing behavior, not end-to-end autonomous delivery. The next constraint is a real governed project pilot.
