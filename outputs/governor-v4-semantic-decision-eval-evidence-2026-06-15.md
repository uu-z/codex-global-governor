# Governor v4 Semantic Decision Eval Evidence

Date: 2026-06-15

Baseline: `v4.0.0`

## Decision

Strengthen the eval harness, not the global prompt.

The next gap after `project_choice / cut_line / proof_pivot` was semantic weakness:

```text
Non-empty decision fields can still be vague.
```

The minimal fix is optional per-case semantic keywords:

```text
expected.must_include
```

This lets adversarial cases require specific decision content without introducing an LLM judge or a new user-facing template.

## What Changed

`scripts/governor-eval.sh` now checks `expected.must_include` when present.

Example shape:

```json
{
  "must_include": {
    "project_choice": ["research"],
    "cut_line": ["launch"],
    "proof_pivot": ["block"]
  }
}
```

The rule is intentionally small:

- only checked when a case opts in
- case-insensitive substring match
- applies to existing response fields
- no new global prompt rule
- no LLM-as-judge dependency

## Evidence

Static validation:

```text
./scripts/governor-eval.sh --dry-run
jq -e . evals/response.schema.json schemas/project-surface-response.schema.json
bash -n scripts/*.sh
git diff --check
```

Representative semantic evals passed:

| Case | Semantic Focus |
|---|---|
| v4-skill-sprawl-is-noise | reject skill routing |
| v4-targeted-research-when-external-truth-can-change-risk | research before launch |
| v4-reject-broad-research-for-local-refactor | cut broad research |
| v4-architecture-precedent-before-custom-build | no custom auth before precedent |
| v4-evidence-verification-before-acceptance | do not accept narrative completion |
| v4-option-stress-test-for-irreversible-choice | do not freeze irreversible architecture |

Full real eval:

```text
outputs/governor-evals/20260615T060049Z.yr0PSD/summary.json
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

The v4 eval suite now proves more than field presence:

```text
The recommendation must contain decision-relevant semantic content for selected adversarial cases.
```

No global prompt patch is justified by this evidence.
