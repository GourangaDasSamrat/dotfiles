#!/usr/bin/env bash
set -euo pipefail
period="${1:?usage: commits-day.sh <today|yesterday>}"

case "$period" in
  today)
    D="$(date +%Y-%m-%d)"
    ;;
  yesterday)
    if [[ "$OSTYPE" == "darwin"* ]]; then D=$(date -v-1d +%Y-%m-%d); else D=$(date -d "yesterday" +%Y-%m-%d); fi
    ;;
  *)
    echo "Unknown period: '$period' (expected: today|yesterday)" >&2
    exit 1
    ;;
esac

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gh search commits --author="@me" --committer-date="$D" --json "repository,commit" \
  | jq -r -f "$DIR/../graphql/filters/commits-day.jq"
