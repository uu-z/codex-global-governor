# Governor v3.4.3 Decision-Layer Residency Evidence

Date: 2026-06-15

Framework version: `v3.4.3`

## Decision

v3.4.2 made taste the control surface. The remaining leak was direct action language: it still left room for the main thread to become resident in execution once scope looked clear.

v3.4.3 makes the boundary sharper:

```text
main attention stays in decision layers
main thread freezes the decision contract
bounded implementation is dispatched below attention
main thread verifies compressed evidence
```

## Changed

- Made decision-layer residency explicit in global behavior truth.
- Tightened direct main-thread action into a one-shot exception.
- Reclassified repeated read/edit/run/check as execution below attention after a frozen decision contract.
- Replaced `Authorize` behavior language with `Freeze -> Dispatch`.
- Restored eval decision language from `authorize` to `dispatch` for clear bounded execution after freeze.
- Added an adversarial eval for clear execution pressure that asks the main thread to personally live inside the transaction loop instead of dispatching a bounded subagent.

## Acceptance

The framework should now treat clear execution as dispatch after freeze, not residency.

Main attention may:

- judge the constraint
- freeze scope, boundary, acceptance, risk, and proof path
- dispatch bounded implementation below attention, ideally to a bounded subagent or execution surface
- verify compressed evidence
- make a one-shot truth or evidence move

Main attention must not:

- own repeated transaction loops
- discover strategy through implementation
- treat clear mechanics as permission to drop altitude

## Verification

- `./scripts/governor-eval.sh --dry-run` passed: validated 23 eval cases.
- `jq -e . evals/response.schema.json schemas/project-surface-response.schema.json` passed.
- `bash -n scripts/*.sh` passed.
- `python3 /Users/test/.codex/skills/.system/skill-creator/scripts/quick_validate.py global/skills/codex-governor` passed.
- `git diff --check` passed.

The targeted eval proves the core v3.4.3 movement: even when execution is clear, the first governor move after freeze is bounded dispatch, not resident execution.
