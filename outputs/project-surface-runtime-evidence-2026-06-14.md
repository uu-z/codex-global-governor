# Project Surface Runtime Evidence

Date: 2026-06-14

Framework version: `v3.2.0`

## Claim

CEO/main-agent project judgment should not depend on self-discipline alone. The runtime must remove transaction-surface input and reject transaction-surface output.

## Evidence Target

The v3.2 runtime provides three gates:

- Input isolation: generated CEO workspace contains global behavior truth and project-level truth, not implementation workspace contents.
- Output structure: CEO response must match the project-level decision schema, including a bounded stop/cut enum instead of free-form stop narration.
- Semantic tripwire: CEO response fails if it leaks transaction-surface language.

## Acceptance

The runtime is acceptable only if:

- `scripts/build-project-surface.sh` creates a project-surface workspace without transaction-surface material.
- `scripts/governor-ceo.sh` runs Codex read-only inside that surface and writes schema-constrained project signal.
- `scripts/validate-project-surface.sh` rejects transaction-surface leakage.
- Existing governor eval dry-run remains valid.

## Strategic Result

This patch moves the CEO boundary from advisory prompt text to a harder I/O boundary. CEO attention stays on project end state, current constraint, project decision, risk, evidence, and stop/cut. CTO/worker runtime remains responsible for transaction details.

## Verification

Completed locally:

- `./scripts/governor-eval.sh --dry-run`: eval definitions valid, 19 cases.
- `./scripts/governor-eval.sh`: full LLM governor eval passed 19/19.
- `./scripts/build-project-surface.sh --project . --out /tmp/codex-governor-surface-test`: generated CEO surface contains only global truth and project entrypoints.
- `./scripts/validate-project-surface.sh /tmp/project-surface-valid.json`: valid project-surface response accepted.
- `./scripts/validate-project-surface.sh /tmp/project-surface-invalid.json`: transaction-surface response rejected.
- `./scripts/governor-ceo.sh --project . -o /tmp/codex-governor-ceo-response.json "<project intent>"`: real Codex CEO run passed schema and semantic project-surface validation.

Observed failure before final shape:

- Free-form `stop_cut` and `project_risk` text allowed low-layer narration to leak back into CEO output.
- Final shape constrains `stop_cut` and `project_risk` to bounded signals.
