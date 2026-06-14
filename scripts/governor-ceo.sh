#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_DIR="$PWD"
SURFACE_DIR=""
MODEL=""
OUT_FILE=""

usage() {
  cat <<'USAGE'
Usage: scripts/governor-ceo.sh [--project DIR] [--surface DIR] [--model MODEL] [-o FILE] [PROMPT]

Runs Codex as a CEO/governor in a hard project-surface workspace.

Hard boundary:
- CEO working directory is the generated project surface, not the real project.
- Sandbox is read-only.
- Output is constrained to project-level decision signal.
- Transaction-surface material is not present.
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
    --surface)
      SURFACE_DIR="${2:-}"
      if [[ -z "$SURFACE_DIR" ]]; then
        echo "missing value for --surface" >&2
        exit 2
      fi
      shift 2
      ;;
    --model)
      MODEL="${2:-}"
      if [[ -z "$MODEL" ]]; then
        echo "missing value for --model" >&2
        exit 2
      fi
      shift 2
      ;;
    -o|--output)
      OUT_FILE="${2:-}"
      if [[ -z "$OUT_FILE" ]]; then
        echo "missing value for --output" >&2
        exit 2
      fi
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      break
      ;;
  esac
done

PROMPT="${*:-}"
if [[ -z "$PROMPT" ]]; then
  if [[ -t 0 ]]; then
    echo "missing prompt" >&2
    usage >&2
    exit 2
  fi
  PROMPT="$(cat)"
fi

if [[ -z "$SURFACE_DIR" ]]; then
  SURFACE_DIR="$ROOT/work/project-surface/$(date -u +%Y%m%dT%H%M%SZ)"
  "$ROOT/scripts/build-project-surface.sh" --project "$PROJECT_DIR" --out "$SURFACE_DIR" >/dev/null
else
  SURFACE_DIR="$(cd "$SURFACE_DIR" && pwd)"
fi

MODEL_ARGS=()
if [[ -n "$MODEL" ]]; then
  MODEL_ARGS=(--model "$MODEL")
fi

TMP_OUT=""
if [[ -z "$OUT_FILE" ]]; then
  TMP_OUT="$(mktemp)"
  OUT_FILE="$TMP_OUT"
fi

cat <<PROMPT_BODY | codex --ask-for-approval never exec \
  -C "$SURFACE_DIR" \
  -s read-only \
  --ephemeral \
  --output-schema "$ROOT/schemas/project-surface-response.schema.json" \
  -o "$OUT_FILE" \
  "${MODEL_ARGS[@]}" \
  - >/dev/null
You are the CEO/governor.

Hard boundary:
- You are in a project-surface workspace, not the real project.
- Do not call tools. The surface has enough truth for the first CEO judgment.
- Do not ask for or infer implementation details.
- Do not narrate or name non-project surface categories.
- Answer only with project-level decision signal matching the schema.
- If lower-layer execution is required, set execution_required=true and state only the project-level reason.
- Choose project_risk enum values; do not explain risks there.
- Choose the stop_cut enum; do not explain it.

Owner intent:
$PROMPT
PROMPT_BODY

"$ROOT/scripts/validate-project-surface.sh" "$OUT_FILE"
cat "$OUT_FILE"

if [[ -n "$TMP_OUT" ]]; then
  rm -f "$TMP_OUT"
fi
