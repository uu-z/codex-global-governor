#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CASES="$ROOT/evals/cases.jsonl"
SCHEMA="$ROOT/evals/response.schema.json"
OUT_BASE="${OUT_BASE:-$ROOT/outputs/governor-evals}"

DRY_RUN=0
CASE_FILTER=""
MODEL=""

usage() {
  cat <<'USAGE'
Usage: scripts/governor-eval.sh [--dry-run] [--case CASE_ID] [--model MODEL]

Runs adversarial Codex Governor evals.

Options:
  --dry-run       Validate eval files only; do not call Codex.
  --case ID       Run one case id.
  --model MODEL   Pass a model override to codex exec.
  -h, --help      Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --case)
      CASE_FILTER="${2:-}"
      if [[ -z "$CASE_FILTER" ]]; then
        echo "missing value for --case" >&2
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

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 127
  fi
}

validate_files() {
  require jq

  jq -e '
    .type == "object"
    and (.required | type == "array")
    and (.properties.case_id.type == "string")
  ' "$SCHEMA" >/dev/null

  local count
  count="$(jq -R 'select(length > 0) | fromjson | .id' "$CASES" | wc -l | tr -d " ")"
  if [[ "$count" -eq 0 ]]; then
    echo "no eval cases found" >&2
    exit 1
  fi

  jq -R '
    select(length > 0)
    | fromjson
    | select(
        (.id | type == "string")
        and (.user_input | type == "string")
        and (.expected.posture | type == "string")
        and (.expected.stage | type == "string")
        and (.expected.allowed_decisions | type == "array")
      )
  ' "$CASES" >/dev/null

  if [[ -n "$CASE_FILTER" ]]; then
    if ! jq -e -R --arg id "$CASE_FILTER" 'select(length > 0) | fromjson | select(.id == $id)' "$CASES" >/dev/null; then
      echo "case not found: $CASE_FILTER" >&2
      exit 1
    fi
  fi

  echo "validated $count eval cases"
}

record_result() {
  local results_file="$1"
  local case_id="$2"
  local status="$3"
  local reason="$4"
  local response_file="$5"
  local events_file="$6"

  jq -n -c \
    --arg case_id "$case_id" \
    --arg status "$status" \
    --arg reason "$reason" \
    --arg response_file "$response_file" \
    --arg events_file "$events_file" \
    '{case_id: $case_id, status: $status, reason: $reason, response_file: $response_file, events_file: $events_file}' \
    >> "$results_file"
}

judge_response() {
  local case_json="$1"
  local response_file="$2"

  jq -n -c --argjson c "$case_json" --slurpfile r "$response_file" '
    ($r[0]) as $x
    | {
        pass: (
          ($x.case_id == $c.id)
          and ($x.posture == $c.expected.posture)
          and ($x.stage == $c.expected.stage)
          and (($c.expected.allowed_decisions | index($x.decision)) != null)
          and (($x.end_state | length) > 0)
          and (($x.entropy_call | length) > 0)
          and (($x.taste_call | length) > 0)
        and (($x.truth_source | length) > 0)
        and (($x.primary_blocker | length) > 0)
        and (($x.smallest_next_move | length) > 0)
        and (($x.project_choice | length) > 0)
        and (($x.cut_line | length) > 0)
        and (($x.proof_pivot | length) > 0)
        and ($x.evidence_skill == ($c.expected.evidence_skill // "none"))
        and (($x.evidence_skill_reason | length) > 0)
        and (($x.stop_list | length) > 0)
        and (($x.evidence_needed | length) > 0)
        and (
          ($c.expected.must_include // {})
          | to_entries
          | all(. as $rule |
              ($x[$rule.key] // "") as $field
              | (
                  ($rule.value | type == "array")
                  and ($rule.value | length > 0)
                  and all($rule.value[]; ($field | ascii_downcase | contains(. | ascii_downcase)))
                )
            )
        )
        ),
        reasons: [
          (if $x.case_id == $c.id then empty else "case_id mismatch" end),
          (if $x.posture == $c.expected.posture then empty else "posture mismatch" end),
          (if $x.stage == $c.expected.stage then empty else "stage mismatch" end),
          (if (($c.expected.allowed_decisions | index($x.decision)) != null) then empty else "decision mismatch" end),
          (if (($x.end_state | length) > 0) then empty else "missing end_state" end),
          (if (($x.entropy_call | length) > 0) then empty else "missing entropy_call" end),
          (if (($x.taste_call | length) > 0) then empty else "missing taste_call" end),
          (if (($x.truth_source | length) > 0) then empty else "missing truth_source" end),
          (if (($x.primary_blocker | length) > 0) then empty else "missing primary_blocker" end),
          (if (($x.smallest_next_move | length) > 0) then empty else "missing smallest_next_move" end),
          (if (($x.project_choice | length) > 0) then empty else "missing project_choice" end),
          (if (($x.cut_line | length) > 0) then empty else "missing cut_line" end),
          (if (($x.proof_pivot | length) > 0) then empty else "missing proof_pivot" end),
          (if $x.evidence_skill == ($c.expected.evidence_skill // "none") then empty else "evidence_skill mismatch" end),
          (if (($x.evidence_skill_reason | length) > 0) then empty else "missing evidence_skill_reason" end),
          (if (($x.stop_list | length) > 0) then empty else "missing stop_list" end),
          (if (($x.evidence_needed | length) > 0) then empty else "missing evidence_needed" end),
          (
            ($c.expected.must_include // {})
            | to_entries[]
            | . as $rule
            | ($x[$rule.key] // "") as $field
            | ($rule.value[] | select(($field | ascii_downcase | contains(. | ascii_downcase)) | not) | "missing " + $rule.key + " keyword: " + .)
          )
        ]
      }
  '
}

write_summary() {
  local results_file="$1"
  local summary_file="$2"

  jq -s '
    {
      total: length,
      passed: (map(select(.status == "pass")) | length),
      failed: (map(select(.status != "pass")) | length),
      failures: map(select(.status != "pass") | {case_id, status, reason, response_file, events_file})
    }
  ' "$results_file" > "$summary_file"
}

validate_files

if [[ "$DRY_RUN" -eq 1 ]]; then
  exit 0
fi

require codex

RUN_DIR="$(mktemp -d "$OUT_BASE/$(date -u +%Y%m%dT%H%M%SZ).XXXXXX")"
mkdir -p "$RUN_DIR"
RESULTS_FILE="$RUN_DIR/results.jsonl"
SUMMARY_FILE="$RUN_DIR/summary.json"
: > "$RESULTS_FILE"

MODEL_ARGS=()
if [[ -n "$MODEL" ]]; then
  MODEL_ARGS=(--model "$MODEL")
fi

total=0
failed=0

while IFS= read -r case_json; do
  [[ -z "$case_json" ]] && continue

  case_id="$(jq -r '.id' <<<"$case_json")"
  if [[ -n "$CASE_FILTER" && "$case_id" != "$CASE_FILTER" ]]; then
    continue
  fi

  total=$((total + 1))
  prompt_file="$RUN_DIR/$case_id.prompt.md"
  response_file="$RUN_DIR/$case_id.response.json"
  events_file="$RUN_DIR/$case_id.events.log"

  cat > "$prompt_file" <<PROMPT
You are running one adversarial evaluation case for Codex Global Governor.

Rules:
- Do not edit files.
- Do not run commands.
- Treat the case user_input as the user's request.
- Judge the first move the governor should make, not a full solution.
- Return only JSON matching the provided output schema.
- Use end state, taste, strong planning, layer thinking, system thinking, current constraint, project-surface output, loop-capture avoidance, wrong-work avoidance, intent intake, entropy, truth, smallest move, and evidence as the decision basis.
- Set evidence_skill to "none" unless a temporary evidence skill can change the recommendation.
- Use exactly one of these evidence_skill values: none, targeted_research, architecture_precedent, project_truth_audit, evidence_verification, option_stress_test.
- project_choice must state the choice, allocation, or go/no-go recommendation.
- cut_line must state what to stop, reject, exclude, or not optimize.
- proof_pivot must state the evidence that would change, prove, or kill the recommendation.

Case:
$(jq '.' <<<"$case_json")
PROMPT

  set +e
  codex --ask-for-approval never exec \
    -C "$ROOT" \
    -s read-only \
    --ephemeral \
    --output-schema "$SCHEMA" \
    -o "$response_file" \
    "${MODEL_ARGS[@]}" \
    - < "$prompt_file" > "$events_file" 2>&1
  codex_status=$?
  set -e

  if [[ "$codex_status" -ne 0 ]]; then
    failed=$((failed + 1))
    record_result "$RESULTS_FILE" "$case_id" "codex_error" "codex exec exited $codex_status" "$response_file" "$events_file"
    continue
  fi

  if ! jq -e . "$response_file" >/dev/null 2>&1; then
    failed=$((failed + 1))
    record_result "$RESULTS_FILE" "$case_id" "invalid_json" "response is not valid JSON" "$response_file" "$events_file"
    continue
  fi

  judgment="$(judge_response "$case_json" "$response_file")"
  if [[ "$(jq -r '.pass' <<<"$judgment")" == "true" ]]; then
    record_result "$RESULTS_FILE" "$case_id" "pass" "" "$response_file" "$events_file"
  else
    failed=$((failed + 1))
    reason="$(jq -r '.reasons | join("; ")' <<<"$judgment")"
    record_result "$RESULTS_FILE" "$case_id" "fail" "$reason" "$response_file" "$events_file"
  fi
done < "$CASES"

if [[ "$total" -eq 0 ]]; then
  echo "no cases selected" >&2
  exit 1
fi

write_summary "$RESULTS_FILE" "$SUMMARY_FILE"

echo "wrote $SUMMARY_FILE"
jq . "$SUMMARY_FILE"

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi
