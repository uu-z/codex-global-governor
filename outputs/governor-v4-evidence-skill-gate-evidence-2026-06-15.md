# Governor v4 Evidence: Decision Value Skill Gate

Date: 2026-06-15

Baseline: `v3.4.3`

## Decision

The v4 direction is now supported by eval evidence:

```text
Decision value governs skill use.
```

The evidence layer should be allowed into v4 design because it improves decision quality without turning the governor into a skill router.

## What Changed

The eval surface now requires:

```text
evidence_skill
evidence_skill_reason
```

Allowed values:

```text
none
targeted_research
architecture_precedent
project_truth_audit
evidence_verification
option_stress_test
```

This does not change user-facing output. It makes the decision gate testable.

## Evidence

Static validation:

```text
./scripts/governor-eval.sh --dry-run
jq -e . evals/response.schema.json schemas/project-surface-response.schema.json
bash -n scripts/*.sh
git diff --check
```

Result:

```text
validated 29 eval cases
all checks passed
```

Targeted v4 real evals passed:

| Case | Expected Skill |
|---|---|
| v4-skill-sprawl-is-noise | none |
| v4-targeted-research-when-external-truth-can-change-risk | targeted_research |
| v4-reject-broad-research-for-local-refactor | none |
| v4-architecture-precedent-before-custom-build | architecture_precedent |
| v4-evidence-verification-before-acceptance | evidence_verification |
| v4-option-stress-test-for-irreversible-choice | option_stress_test |

Full real eval before global prompt upgrade:

```text
outputs/governor-evals/20260615T051702Z.XSxGAE/summary.json
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

Full real eval after global prompt upgrade:

```text
outputs/governor-evals/20260615T053228Z.i9UKLz/summary.json
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

## Important Finding

The first full run failed on `resume-focus` because the model selected:

```text
project_truth_audit
```

That was the correct v4 behavior. Session resume and context drift are valid Project Truth Audit cases because reading the smallest project truth can change the next-move recommendation.

The eval expectation was updated accordingly.

## Entropy Check

This patch adds proof surface, not process surface.

It avoids:

- mandatory skill use
- standing skill teams
- broad research by default
- new user-facing templates
- global prompt upgrade before proof

It enables:

- rejecting skill sprawl
- using targeted research only when outside truth changes the recommendation
- finding architecture precedent before custom builds
- requiring evidence before completion acceptance
- stress-testing irreversible decisions
- auditing project truth on resume/context drift

## Next Decision

The next valuable move is a minimal v4 kernel delta:

```text
Add Decision Value and Evidence Skill Gate to global behavior truth.
```

Do not add more skills.

Do not expand output templates.

Do not implement v5 strategic search yet.
