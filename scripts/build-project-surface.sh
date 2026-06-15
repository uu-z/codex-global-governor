#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_DIR="$PWD"
OUT_DIR=""

usage() {
  cat <<'USAGE'
Usage: scripts/build-project-surface.sh [--project DIR] [--out DIR]

Builds a project-surface workspace for governed judgment.

The surface copies only top-level project truth and global governor truth.
It intentionally excludes transaction-surface material.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_DIR="${2:-}"
      if [[ -z "$PROJECT_DIR" ]]; then
        echo "missing value for --project" >&2
        exit 2
      fi
      shift 2
      ;;
    --out)
      OUT_DIR="${2:-}"
      if [[ -z "$OUT_DIR" ]]; then
        echo "missing value for --out" >&2
        exit 2
      fi
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
if [[ -z "$OUT_DIR" ]]; then
  OUT_DIR="$ROOT/work/project-surface/$(date -u +%Y%m%dT%H%M%SZ)"
fi
if [[ -d "$OUT_DIR" && -n "$(find "$OUT_DIR" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
  echo "output directory must be empty: $OUT_DIR" >&2
  exit 2
fi
mkdir -p "$OUT_DIR/global" "$OUT_DIR/project" "$OUT_DIR/project/truth-docs"

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp -p "$src" "$dst"
  fi
}

copy_if_exists "$ROOT/global/AGENTS.md" "$OUT_DIR/AGENTS.md"
copy_if_exists "$ROOT/global/KERNEL.md" "$OUT_DIR/global/KERNEL.md"
copy_if_exists "$ROOT/global/HARNESS.md" "$OUT_DIR/global/HARNESS.md"
copy_if_exists "$ROOT/global/GOVERNOR-VERSION.md" "$OUT_DIR/global/GOVERNOR-VERSION.md"
copy_if_exists "$ROOT/global/skills/codex-governor/SKILL.md" "$OUT_DIR/global/skills/codex-governor/SKILL.md"

for name in AGENTS.md MASTER-BLUEPRINT.md README.md HARNESS.md GOVERNOR-VERSION.md ROADMAP.md STRATEGY.md ARCHITECTURE.md STATUS.md ACCEPTANCE.md WHITEPAPER.md CHARTER.md PROJECT-CHARTER.md PRD.md EXECUTION-PLAN.md PRODUCT-STRATEGY.md; do
  copy_if_exists "$PROJECT_DIR/$name" "$OUT_DIR/project/$name"
done

while IFS= read -r src; do
  rel="${src#$PROJECT_DIR/}"
  if [[ -f "$OUT_DIR/project/$rel" ]]; then
    continue
  fi
  copy_if_exists "$src" "$OUT_DIR/project/truth-docs/$rel"
done < <(
  find "$PROJECT_DIR" -maxdepth 5 -type f \
    \( -name '*.md' -o -name '*.txt' \) \
    ! -path "$PROJECT_DIR/.git/*" \
    ! -path "$PROJECT_DIR/node_modules/*" \
    ! -path "$PROJECT_DIR/src/*" \
    ! -path "$PROJECT_DIR/app/*" \
    ! -path "$PROJECT_DIR/lib/*" \
    ! -path "$PROJECT_DIR/packages/*" \
    ! -path "$PROJECT_DIR/tests/*" \
    ! -path "$PROJECT_DIR/test/*" \
    ! -path "$PROJECT_DIR/artifacts/*" \
    ! -path "$PROJECT_DIR/logs/*" \
    ! -path "$PROJECT_DIR/dist/*" \
    ! -path "$PROJECT_DIR/build/*" \
    ! -path "$PROJECT_DIR/coverage/*" \
    ! -path "$PROJECT_DIR/outputs/*" \
    ! -path "$PROJECT_DIR/work/*" \
    | grep -Ei '/([^/]*(blueprint|whitepaper|strategy|architecture|execution[-_ ]?plan|roadmap|status|acceptance|charter|saed|prd)[^/]*)$' \
    | sort \
    || true
)

cat > "$OUT_DIR/PROJECT-SURFACE.md" <<SURFACE
# Project Surface

Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)

Source project:

\`\`\`text
$PROJECT_DIR
\`\`\`

This workspace is a project-surface view. It intentionally excludes transaction-surface material.

Top-level truth is copied from explicit project entrypoints and semantically named strategic documents under project/truth-docs/.

Allowed main attention:

\`\`\`text
End State
End-State Fit
Current Constraint
Project Choice
Cut Line
Proof Pivot
Project Decision
Project Risk
Project Evidence
Stop / Cut
\`\`\`

If implementation is required, keep it in the real project workspace below main attention.
SURFACE

find "$OUT_DIR" -type f | sort
