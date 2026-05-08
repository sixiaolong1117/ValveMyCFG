#!/usr/bin/env bash
set -euo pipefail

ASCII_FOOTER=$(cat <<'EOF'
echo "                                ,----, "
echo "             ,---.-,          .'   .`| "
echo "    ,---,.  '   ,'  '.     .'   .'   ; "
echo "  ,'  .' | /   /      \  ,---, '    .' "
echo ",---.'   |.   ;  ,/.  :  |   :     ./  "
echo "|   |   .''   |  | :  ;  ;   | .'  /   "
echo ":   :  :  '   |  ./   :  `---' /  ;    "
echo ":   |  |-,|   :       ,    /  ;  /     "
echo "|   :  ;/| \   \      |   ;  /  /      "
echo "|   |   .'  `---`---  ;  /  /  /       "
echo "'   :  '       |   |  |./__;  /        "
echo "|   |  |       '   :  ;|   : /         "
echo "|   :  \       |   |  ';   |/          "
echo "|   | ,'       ;   |.' `---'           "
echo "`----'         '---'                   "

echo "================================="
echo "=  F97 configuration is ready!  ="
EOF
)

LICENSE_PART=$(cat <<'EOF'
echo "=   SIXiaolong1117/ValveMyCFG   ="
echo "=          MIT license          ="
echo "================================="
EOF
)

is_zero_sha() {
  [[ "$1" =~ ^0+$ ]]
}

ensure_ref_exists() {
  local ref="$1"
  if ! git rev-parse --verify --quiet "$ref" >/dev/null; then
    git fetch --no-tags origin "$ref":"refs/remotes/origin/$ref"
  fi
}

get_changed_cfg_files() {
  if [[ -n "${CFG_CHANGED_FILES:-}" ]]; then
    printf '%s\n' "$CFG_CHANGED_FILES" | while IFS= read -r file; do
      [[ "$file" == *.cfg ]] && [[ -f "$file" ]] && printf '%s\0' "$file"
    done
    return
  fi

  case "${GITHUB_EVENT_NAME:-}" in
    push)
      local before="${GITHUB_EVENT_BEFORE:-}"
      local after="${GITHUB_SHA:-HEAD}"
      if [[ -n "$before" ]] && ! is_zero_sha "$before"; then
        git diff --name-only -z --diff-filter=ACMRT "$before" "$after" -- '*.cfg'
      else
        git diff-tree --no-commit-id --name-only -z -r --diff-filter=ACMRT "$after" -- '*.cfg'
      fi
      ;;
    pull_request|pull_request_target)
      local base_ref="${GITHUB_BASE_REF:-}"
      if [[ -n "$base_ref" ]]; then
        ensure_ref_exists "$base_ref"
        git diff --name-only -z --diff-filter=ACMRT "origin/$base_ref"...HEAD -- '*.cfg'
      else
        git diff-tree --no-commit-id --name-only -z -r --diff-filter=ACMRT HEAD -- '*.cfg'
      fi
      ;;
    *)
      git diff-tree --no-commit-id --name-only -z -r --diff-filter=ACMRT HEAD -- '*.cfg'
      ;;
  esac
}

get_file_date() {
  local file="$1"
  local date_value

  date_value=$(git log -1 --format="%ad" --date=format:'%Y.%m.%d' -- "$file" 2>/dev/null || true)
  if [[ -z "$date_value" ]]; then
    date_value=$(date +%Y.%m.%d)
  fi

  printf '%s\n' "$date_value"
}

update_footer_date() {
  local file="$1"
  local date_value="$2"

  sed -i -E \
    "s/echo \"= *[0-9]{4}\.[0-9]{2}\.[0-9]{2} *=/echo \"=           ${date_value}          =/g" \
    "$file"
}

append_footer() {
  local file="$1"
  local date_value="$2"

  {
    echo ""
    echo "$ASCII_FOOTER"
    echo "echo \"=           ${date_value}          =\""
    echo "$LICENSE_PART"
  } >> "$file"
}

mapfile -d '' changed_cfg_files < <(get_changed_cfg_files)

if (( ${#changed_cfg_files[@]} == 0 )); then
  echo "No cfg files changed in this commit range."
  exit 0
fi

for file in "${changed_cfg_files[@]}"; do
  [[ -f "$file" ]] || continue

  echo "Checking $file ..."
  file_date=$(get_file_date "$file")

  if grep -q "F97 configuration is ready!" "$file"; then
    update_footer_date "$file" "$file_date"
  else
    append_footer "$file" "$file_date"
    echo "Footer added to $file"
  fi
done
