#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/validate-project-surface.sh RESPONSE_JSON

Validates that a CEO/governor response stays on the project surface.
This is a semantic tripwire, not a full JSON Schema implementation.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

RESPONSE_FILE="${1:-}"
if [[ -z "$RESPONSE_FILE" ]]; then
  echo "missing response file" >&2
  usage >&2
  exit 2
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "missing required command: jq" >&2
  exit 127
fi

jq -e '
  type == "object"
  and ((keys_unsorted | sort) == ([
    "current_constraint",
    "end_state",
    "execution_required",
    "project_decision",
    "project_evidence",
    "project_risk",
    "stop_cut"
  ] | sort))
  and (.end_state | type == "string" and length > 0)
  and (.current_constraint | type == "string" and length > 0)
  and (.project_decision | type == "string" and length > 0)
  and (.project_risk | type == "array" and length > 0 and all(.[]; (
    . == "soft_boundary_regression"
    or . == "surface_area_growth"
    or . == "missing_acceptance_signal"
    or . == "truth_split"
    or . == "strategy_sprawl"
    or . == "evidence_gap"
    or . == "none"
  )))
  and (.project_evidence | type == "array" and all(.[]; type == "string" and length > 0))
  and (.stop_cut | type == "string" and (
    . == "cut_non_project_surface"
    or . == "cut_wrong_direction"
    or . == "cut_missing_evidence"
    or . == "cut_strategy_sprawl"
    or . == "cut_none"
  ))
  and (.execution_required | type == "boolean")
' "$RESPONSE_FILE" >/dev/null

TEXT="$(jq -r '.. | strings' "$RESPONSE_FILE")"

deny_patterns=(
  '(^|[[:space:]])(\./|\.\./)'
  '(^|[[:space:]])/Users/'
  '(^|[[:space:]])(src|app|lib|packages|tests?|scripts)/'
  '\.(ts|tsx|js|jsx|py|go|rs|sol|sql|css|html|ya?ml|toml|sh)([[:space:][:punct:]]|$)'
  '(^|[[:space:]])(npm|pnpm|yarn|git|rg|grep|sed|awk|pytest|cargo|docker|kubectl|make)([[:space:]]|$)'
  '(diff --git|stack trace|traceback|stdout|stderr|exit code|line [0-9]+|@@)'
  '(read files|edit code|run tests|patch again|work log|implementation step)'
  '(读取文件|编辑代码|运行测试|命令输出|工作日志|实现步骤)'
)

for pattern in "${deny_patterns[@]}"; do
  if grep -Eiq "$pattern" <<<"$TEXT"; then
    echo "project-surface violation: response contains transaction-surface language" >&2
    exit 1
  fi
done
