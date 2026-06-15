# Governor Evals

Purpose: prove whether the governor protects taste, constraint, and evidence instead of optimizing local activity.

These evals are adversarial. They test the first governor move under pressure:

- stop noise
- reject entropy
- protect end state
- preserve truth
- demand evidence
- avoid implementation drift

## Run

Validate case and schema shape only:

```bash
./scripts/governor-eval.sh --dry-run
```

Run all model evals locally:

```bash
./scripts/governor-eval.sh
```

Run one case:

```bash
./scripts/governor-eval.sh --case no-evidence-prompt-bloat
```

Use a specific model:

```bash
./scripts/governor-eval.sh --model gpt-5.3-codex
```

## Output

Each run writes evidence under:

```text
outputs/governor-evals/<timestamp>/
```

Key files:

- `results.jsonl`: one result per case
- `summary.json`: pass/fail summary
- `<case>.response.json`: structured governor response
- `<case>.events.log`: raw Codex CLI events and errors

## Rule

The eval runner never edits the governor prompt.

Failures are evidence. A prompt patch is allowed only after repeated failure shows the smallest rule that makes the failure disappear.
