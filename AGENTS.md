# Project Instructions

Framework version: `v2.4.0`.

This project designs and evolves the global Codex Governor framework.

Use the exported global governor kernel as behavior truth:

- `global/AGENTS.md`
- `global/KERNEL.md`
- `global/HARNESS.md`
- `global/skills/codex-governor/SKILL.md`

Do not duplicate the global kernel here. This file is only for project-specific truth and resume guidance.

## Project Truth

- Strategy truth: `MASTER-BLUEPRINT.md`
- Local mental model: `HARNESS.md`
- Version truth: `global/GOVERNOR-VERSION.md`
- Governor eval truth: `evals/`
- User-facing deliverables: `outputs/`

## Resume

On a new session, read the smallest useful project truth:

1. `MASTER-BLUEPRINT.md`
2. `global/GOVERNOR-VERSION.md`
3. `HARNESS.md` only if project-local context is needed
4. `outputs/` only for specific evidence

Infer objective, end state, current project truth, blocker, taste bar, and next visible progress.

## Project Constraints

- Update global source files first when changing governor behavior.
- Update project docs only when they record project truth or evidence.
- Do not create new governor routes, rituals, or skills without failure evidence.
- Use `./scripts/governor-eval.sh --dry-run` before changing eval structure.
- Proactively patch recurring governor drift; do not wait for owner prompting when evidence is clear.
- Keep this project as a framework lab, not a second global prompt.
