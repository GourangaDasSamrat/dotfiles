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

DATA=$(gh search commits --author="@me" --committer-date="$D" --json "repository" \
  --jq 'group_by(.repository.fullName) | .[] | {repo: .[0].repository.fullName, count: length}')

echo "$DATA" | jq -r '"\u001b[38;5;141m➜ \(.repo)\u001b[0m \u001b[38;5;117m➜\u001b[0m \u001b[38;5;84m\(.count) commits\u001b[0m"'

TOTAL=$(echo "$DATA" | jq -s 'map(.count) | add // 0')
echo -e "\n\u001b[38;5;141mTotal Commits ${LABEL}:\u001b[0m \u001b[38;5;84m${TOTAL}\u001b[0m"
