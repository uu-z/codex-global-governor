# Governor v3.4 Layer Percent Evidence

Date: 2026-06-15

Framework version: `v3.4.0`

## Judgment

v3.4 moves the governor from single readiness scoring to layer-percent judgment.

Core behavior:

- The main agent thinks by each important layer's percentage fit to the end state.
- The current constraint is selected from the lowest high-leverage layer gap.
- Layer percentages are thinking core, not a scorecard ritual.
- Output structure is optional and must collapse into judgment when it becomes ceremony.

## Hard Runtime Evidence

Command:

```text
./scripts/governor-ceo.sh --project . "当前 governor 框架是否已经足够避免刻板化，并按层级百分比选择下一约束？"
```

Result:

- Passed `schemas/project-surface-response.schema.json`.
- Passed `scripts/validate-project-surface.sh`.
- Response included `layer_percentages`.
- CEO judgment did not accept completion; it selected evidence as the weakest layer.

Layer percentages returned:

| Layer | Fit |
|---|---:|
| strategy | 84 |
| architecture | 76 |
| product_acceptance | 63 |
| operability | 58 |
| evidence | 42 |

Current constraint returned:

```text
Evidence/independent proof: the framework now states the anti-template and layer-percentage decision rules, but the surface truth does not prove repeatable behavior across varied governor prompts.
```

## Targeted Eval Evidence

Command:

```text
./scripts/governor-eval.sh --case layer-percentage-constraint
```

Result:

```json
{
  "total": 1,
  "passed": 1,
  "failed": 0,
  "failures": []
}
```

Evidence path:

```text
outputs/governor-evals/20260615T031611Z/
```

The eval response selected the lowest high-leverage layer gap:

| Layer | Fit |
|---|---:|
| Core protocol | 90 |
| Docs | 80 |
| Frontend product surface | 45 |
| External tester flow | 55 |
| Evidence / independent proof | 60 |

Primary blocker returned:

```text
Frontend product surface at 45% is the lowest high-leverage gap to terminal acceptance, with external tester flow as the immediate proof path.
```

## Acceptance State

## Full Eval Evidence

Command:

```text
./scripts/governor-eval.sh
```

Result:

```json
{
  "total": 21,
  "passed": 21,
  "failed": 0,
  "failures": []
}
```

Evidence path:

```text
outputs/governor-evals/20260615T031814Z/
```

## Acceptance State

v3.4 has enough proof to land the mechanism:

- The hard CEO runtime schema now requires `layer_percentages`.
- The project-surface validator enforces `layer_percentages`.
- The governor eval schema now requires `layer_percentages`.
- A real eval case proves the governor chooses the current constraint from layer percentages instead of task loudness.
- The full 21-case governor eval suite passed after adding the `layer_percentages` requirement.
