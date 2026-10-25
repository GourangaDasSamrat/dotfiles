#!/usr/bin/env bash
set -euo pipefail
period="${1:?usage: commits-day-summary.sh <today|yesterday>}"

case "$period" in
  today)
    D="$(date +%Y-%m-%d)"
    LABEL="Today"
    ;;
  yesterday)
    if [[ "$OSTYPE" == "darwin"* ]]; then D=$(date -v-1d +%Y-%m-%d); else D=$(date -d "yesterday" +%Y-%m-%d); fi
    LABEL="Yesterday"
    ;;
  *)
    echo "Unknown period: '$period' (expected: today|yesterday)" >&2
    exit 1
    ;;
esac

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gh search commits --author="@me" --committer-date="$D" --json "repository" \
  | jq -r --arg label "$LABEL" -f "$DIR/../graphql/filters/commits-day-summary.jq"
