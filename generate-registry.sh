#!/usr/bin/env bash
# Scans plugins/ and regenerates registry.json

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$SCRIPT_DIR/plugins"
REGISTRY_FILE="$SCRIPT_DIR/registry.json"
GENERATED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  echo "$s"
}

extract_string_field() {
  local file="$1"
  local field="$2"
  perl -0777 -ne "if (/\"${field}\"\s*:\s*\"([^\"]+)\"/) { print \$1; exit }" "$file" 2>/dev/null || echo ""
}

extract_bool_field() {
  local file="$1"
  local field="$2"
  perl -0777 -ne "if (/\"${field}\"\s*:\s*(true|false)/) { print \$1; exit }" "$file" 2>/dev/null || echo "false"
}

extract_array_field() {
  local file="$1"
  local field="$2"
  perl -0777 -ne "
    if (/\"${field}\"\s*:\s*\[([^\]]*)\]/) {
      my \$arr = \$1;
      my @items = (\$arr =~ /\"([^\"]+)\"/g);
      print join(',', map { '\"' . \$_ . '\"' } @items);
    }
  " "$file" 2>/dev/null || echo ""
}

collect_files() {
  local plugin_dir="$1"
  local files=()

  if [ -d "$plugin_dir/commands" ]; then
    while IFS= read -r -d '' f; do
      files+=("\"commands/$(basename "$f")\"")
    done < <(find "$plugin_dir/commands" -name "*.md" -print0 | sort -z)
  fi

  if [ -d "$plugin_dir/agents" ]; then
    while IFS= read -r -d '' f; do
      files+=("\"agents/$(basename "$f")\"")
    done < <(find "$plugin_dir/agents" -name "*.md" -print0 | sort -z)
  fi

  if [ -d "$plugin_dir/skills" ]; then
    while IFS= read -r -d '' f; do
      rel="${f#$plugin_dir/}"
      files+=("\"$rel\"")
    done < <(find "$plugin_dir/skills" -name "*.md" -print0 | sort -z)
  fi

  echo "[$(IFS=,; echo "${files[*]}")]"
}

detect_type() {
  local plugin_dir="$1"
  local has_commands=false
  local has_agents=false
  local has_mcp=false

  [ -d "$plugin_dir/commands" ] && [ -n "$(ls "$plugin_dir/commands"/*.md 2>/dev/null)" ] && has_commands=true
  [ -d "$plugin_dir/agents" ]   && [ -n "$(ls "$plugin_dir/agents"/*.md 2>/dev/null)" ]   && has_agents=true
  [ -f "$plugin_dir/mcp/server.json" ] && has_mcp=true

  if $has_mcp; then
    echo "mcp"
  elif $has_commands && $has_agents; then
    echo "bundle"
  elif $has_agents; then
    echo "agent"
  else
    echo "skill"
  fi
}

build_mcp_block() {
  local mcp_file="$1"
  local server_key type command args env bundle_version bundle_url

  server_key="$(extract_string_field "$mcp_file" "serverKey")"
  type="$(extract_string_field "$mcp_file" "type")"
  command="$(extract_string_field "$mcp_file" "command")"
  bundle_version="$(extract_string_field "$mcp_file" "bundleVersion")"
  bundle_url="$(extract_string_field "$mcp_file" "bundleUrl")"

  args="$(jq -c '.args // []' "$mcp_file" 2>/dev/null)" || {
    echo "ERROR: $mcp_file has invalid or missing 'args' — must be valid JSON" >&2
    exit 1
  }
  env="$(jq -c '.env // {}' "$mcp_file" 2>/dev/null)" || {
    echo "ERROR: $mcp_file has invalid or missing 'env' — must be valid JSON" >&2
    exit 1
  }

  if ! echo "$args" | jq -e 'type == "array"' >/dev/null 2>&1; then
    echo "ERROR: $mcp_file 'args' must be a JSON array" >&2
    exit 1
  fi
  if ! echo "$env" | jq -e 'type == "object"' >/dev/null 2>&1; then
    echo "ERROR: $mcp_file 'env' must be a JSON object" >&2
    exit 1
  fi

  cat <<EOF
      "mcp": {
        "serverKey": "$(json_escape "$server_key")",
        "type": "$(json_escape "$type")",
        "command": "$(json_escape "$command")",
        "args": $args,
        "env": $env,
        "bundleVersion": "$(json_escape "$bundle_version")",
        "bundleUrl": "$(json_escape "$bundle_url")"
      },
EOF
}

# ── Main ──────────────────────────────────────────────────────────────────────

plugin_entries=()

for plugin_dir in "$PLUGINS_DIR"/*/; do
  manifest="$plugin_dir/.claude-plugin/plugin.json"
  [ -f "$manifest" ] || continue

  name="$(extract_string_field "$manifest" "name")"
  version="$(extract_string_field "$manifest" "version")"
  description="$(extract_string_field "$manifest" "description")"
  author_name="$(extract_string_field "$manifest" "name")"  # inside author block — re-extract
  author_name="$(perl -0777 -ne 'if (/"author"\s*:\s*\{[^}]*"name"\s*:\s*"([^"]+)"/) { print $1; exit }' "$manifest" 2>/dev/null || echo "")"

  artifact_name="$(perl -0777 -ne 'if (/"artifactName"\s*:\s*"([^"]+)"/) { print $1; exit }' "$manifest" 2>/dev/null || echo "")"
  owner="$(perl -0777 -ne 'if (/"metadata".*?"owner"\s*:\s*"([^"]+)"/s) { print $1; exit }' "$manifest" 2>/dev/null || echo "")"
  classification="$(perl -0777 -ne 'if (/"maxDataClassification"\s*:\s*"([^"]+)"/) { print $1; exit }' "$manifest" 2>/dev/null || echo "")"
  llm_model="$(perl -0777 -ne 'if (/"llmModel"\s*:\s*"([^"]+)"/) { print $1; exit }' "$manifest" 2>/dev/null || echo "any")"
  network_exposure="$(perl -0777 -ne 'if (/"networkExposure"\s*:\s*"([^"]+)"/) { print $1; exit }' "$manifest" 2>/dev/null || echo "none")"
  write_actions="$(extract_bool_field "$manifest" "writeActions")"
  approval_status="$(perl -0777 -ne 'if (/"approvalStatus"\s*:\s*"([^"]+)"/) { print $1; exit }' "$manifest" 2>/dev/null || echo "pending")"
  last_reviewed="$(perl -0777 -ne 'if (/"lastReviewedDate"\s*:\s*"([^"]+)"/) { print $1; exit }' "$manifest" 2>/dev/null || echo "")"
  ext_deps="$(extract_array_field "$manifest" "externalDependencies")"

  type="$(detect_type "$plugin_dir")"
  files="$(collect_files "$plugin_dir")"

  mcp_block=""
  if [ "$type" = "mcp" ] && [ -f "$plugin_dir/mcp/server.json" ]; then
    mcp_block="$(build_mcp_block "$plugin_dir/mcp/server.json")"
  fi

  entry=$(cat <<EOF
    {
      "name": "$(json_escape "$name")",
      "version": "$(json_escape "$version")",
      "type": "$type",
      "description": "$(json_escape "$description")",
      "author": "$(json_escape "$author_name")",
$mcp_block      "files": $files,
      "metadata": {
        "artifactName": "$(json_escape "$artifact_name")",
        "owner": "$(json_escape "$owner")",
        "maxDataClassification": "$(json_escape "$classification")",
        "llmModel": "$(json_escape "$llm_model")",
        "networkExposure": "$(json_escape "$network_exposure")",
        "externalDependencies": [$ext_deps],
        "writeActions": $write_actions,
        "approvalStatus": "$(json_escape "$approval_status")",
        "lastReviewedDate": "$(json_escape "$last_reviewed")"
      }
    }
EOF
)
  plugin_entries+=("$entry")
done

# Join entries with commas
joined=""
for i in "${!plugin_entries[@]}"; do
  if [ $i -gt 0 ]; then
    joined="$joined,"
  fi
  joined="$joined
${plugin_entries[$i]}"
done

cat > "$REGISTRY_FILE" <<EOF
{
  "schema": "1.0.0",
  "generated": "$GENERATED_AT",
  "plugins": [$joined
  ]
}
EOF

echo "Registry generated: $REGISTRY_FILE"
echo "Plugins found: ${#plugin_entries[@]}"
