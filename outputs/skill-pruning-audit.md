# Skill Pruning Audit

Date: 2026-06-13

## Objective

Audit the active local skill surface and identify low-value or noisy entries to remove from default routing.

This audit does not permanently delete global skill directories. It identifies safe pruning candidates, updates the governor top-level plan, and records the first reversible quarantine pass.

## Stage

`governed / 0-90`

Actual deletion is `90-100` only after the user confirms the removal boundary.

## Truth

Observed skill roots:

- `/Users/test/.codex/skills`
- `/Users/test/.agents/skills`
- `/Users/test/.gstack/repos/gstack/.agents/skills`
- `/Users/test/.codex/plugins/cache/openai-bundled`

Initial observed counts:

- Total `SKILL.md`: 349
- Active excluding archived: 295
- Archived: 54
- System/plugin: 8
- Active under `.codex/skills`: 51
- Active under `.agents/skills`: 197
- Active under gstack repo skills: 66

Post-quarantine observed counts:

- Total `SKILL.md`: 268
- Active excluding archived: 268
- Archived: 0
- System/plugin: 8
- Active under `.codex/skills`: 51
- Active under `.agents/skills`: 170
- Active under gstack repo skills: 39
- Remaining duplicate skill names: 29

Quarantined `SKILL.md`: 81

Manifest:

- `outputs/quarantine-manifest-2026-06-13.md`
- `outputs/remaining-skill-duplicates-2026-06-13.md`

## Primary Finding

The main entropy source is not one bad skill. It is too many active routes with overlapping intent.

Best pruning move:

```text
delete active routing noise, not knowledge assets
```

## Low-Value Classes

### 1. Archived GSD Skills

Status: already archived.

Examples:

- `.archived-gsd/gsd-add-backlog`
- `.archived-gsd/gsd-plan-phase`
- `.archived-gsd/gsd-execute-phase`
- `.archived-gsd/gsd-ship`

Decision: keep archived or physically delete later. Do not expose as active routes.

Reason: obsolete workflow surface; current governor kernel replaces most of the control-plane value.

### 2. Duplicate gstack Skills

Status: high-confidence duplicate noise.

Duplicated names include:

- `autoplan`
- `benchmark`
- `browse`
- `canary`
- `careful`
- `cso`
- `design-consultation`
- `design-review`
- `document-release`
- `freeze`
- `gstack`
- `gstack-upgrade`
- `guard`
- `investigate`
- `land-and-deploy`
- `office-hours`
- `plan-ceo-review`
- `plan-design-review`
- `plan-eng-review`
- `qa`
- `qa-only`
- `review`
- `ship`
- `setup-deploy`
- `unfreeze`

Decision: keep one canonical gstack source; remove or quarantine nested/vendor duplicates only after confirming which root Codex loads first.

Reason: duplicate names increase trigger ambiguity and make behavior depend on load order.

First-cut result:

- Quarantined nested ignored copy: `/Users/test/.agents/skills/gstack/.agents`
- Kept `/Users/test/.agents/skills/gstack` direct subskills because that repo has uncommitted modifications.
- Kept `/Users/test/.gstack/repos/gstack/.agents/skills` as canonical repo source.

### 3. Over-Sliced Product Workshop Skills

Status: useful knowledge, low default-route value.

Candidate consolidation:

- `problem-statement`
- `problem-framing-canvas`
- `lean-ux-canvas`
- `jobs-to-be-done`
- `proto-persona`
- `customer-journey-map`
- `customer-journey-mapping-workshop`
- `opportunity-solution-tree`
- `positioning-statement`
- `positioning-workshop`
- `prd-development`
- `roadmap-planning`
- `user-story`
- `user-story-mapping`
- `user-story-mapping-workshop`
- `user-story-splitting`

Decision: demote behind one product-strategy router skill.

Reason: individually useful, collectively too granular for default routing.

### 4. Over-Sliced SaaS Finance / Business Skills

Status: useful, but too many narrow entrypoints.

Candidate consolidation:

- `saas-revenue-growth-metrics`
- `saas-economics-efficiency-metrics`
- `finance-based-pricing-advisor`
- `finance-metrics-quickref`
- `business-health-diagnostic`
- `feature-investment-advisor`
- `acquisition-channel-advisor`
- `tam-sam-som-calculator`

Decision: demote behind one business-analysis router skill.

Reason: narrow metric skills should be references or subroutes, not active top-level routes.

### 5. Redundant Writing Skills

Status: medium-value, narrow.

Candidate consolidation:

- `writing-beats`
- `writing-fragments`
- `writing-shape`
- `edit-article`

Decision: demote behind one writing skill.

Reason: interaction styles differ, but top-level routing cost is higher than the benefit.

### 6. Redundant Skill Authoring Skills

Status: duplicate intent.

Candidates:

- `skill-creator`
- `write-a-skill`
- `skill-authoring-workflow`
- `setup-matt-pocock-skills`

Decision: keep `skill-creator` as canonical for Codex skills; demote the rest unless the specific ecosystem is requested.

Reason: too many ways to ask for the same meta-skill workflow.

### 7. Governor Escalation Skills

Status: previously over-sliced by us.

Removed from top-level plan:

- `claim-review`
- `risk-budget`
- `option-commit`
- `freedom-audit`

Decision: merge into `entropy-audit`.

Reason: these are diagnostic lenses, not independent default skills.

## Keep As Active / High-Value

### System / Platform

- `openai-docs`
- `skill-creator`
- `skill-installer`
- `plugin-creator`
- `control-in-app-browser`
- `control-chrome`

### Governor / Control Plane

- `codex-governor`
- `project-lead-agent-team`
- `project-goal-loop`
- `verify`
- `recover`
- `blocker`
- `razor`
- `trim`
- `slice`
- `glue`
- `stabilize`
- `audit`

### High-Leverage Engineering

- `diagnose`
- `tdd`
- `review`
- `polish`
- `next-best-practices`
- `vercel-react-best-practices`
- `shadcn`
- `hono`
- `ai-sdk`
- `native-data-fetching`
- `pdf`
- `doc`

### High-Leverage Design / Prototype

- `imagegen`
- `imagegen-frontend-web`
- `imagegen-frontend-mobile`
- `image-to-code`
- `react-prototype-to-flutter`
- `huashu-design`
- `high-end-visual-design`

## Recommended Removal Boundary

Completed first cut:

1. Keep all system/plugin skills.
2. Keep all specialist implementation skills on disk.
3. Remove top-level governor skills from 7 to 4.
4. Quarantine archived GSD and archived Paseo.
5. Quarantine nested ignored gstack copy.
6. Keep dirty gstack repo direct subskills in place until load precedence and repo state are resolved.

## Next Action

If further deletion is desired, do it in this order:

1. Resolve or intentionally preserve uncommitted changes in `/Users/test/.agents/skills/gstack`.
2. Decide canonical gstack source: `/Users/test/.agents/skills/gstack` or `/Users/test/.gstack/repos/gstack`.
3. Quarantine the non-canonical gstack source.
4. Run skill discovery again.
5. Verify expected active skill count and duplicate-name count.
6. Only then permanently delete quarantined copies.
