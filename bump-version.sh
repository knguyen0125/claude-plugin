#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <plugin-name> [major|minor|patch]"
  echo ""
  echo "  plugin-name   Name of the plugin (e.g., engineering, general, executive, product)"
  echo "  bump-type     Semver bump type (default: patch)"
  echo ""
  echo "Examples:"
  echo "  $0 engineering          # 1.0.4 → 1.0.5"
  echo "  $0 engineering minor    # 1.0.4 → 1.1.0"
  echo "  $0 engineering major    # 1.0.4 → 2.0.0"
  exit 1
}

[[ $# -lt 1 ]] && usage

PLUGIN="$1"
BUMP="${2:-patch}"
JSON="plugins/$PLUGIN/.claude-plugin/plugin.json"

if [[ ! -f "$JSON" ]]; then
  echo "Error: $JSON not found" >&2
  exit 1
fi

if [[ "$BUMP" != "major" && "$BUMP" != "minor" && "$BUMP" != "patch" ]]; then
  echo "Error: bump type must be major, minor, or patch (got '$BUMP')" >&2
  exit 1
fi

CURRENT=$(grep -o '"version": *"[^"]*"' "$JSON" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$BUMP" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
esac

NEW="$MAJOR.$MINOR.$PATCH"

sed -i "s/\"version\": *\"$CURRENT\"/\"version\": \"$NEW\"/" "$JSON"

echo "$PLUGIN: $CURRENT → $NEW"
