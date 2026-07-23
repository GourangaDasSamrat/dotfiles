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

gh search commits --author="@me" --committer-date="$D" --json "repository,commit" \
  --jq 'sort_by(.commit.author.date) | .[] | "\u001b[38;5;117m[\(.commit.author.date[11:16])]\u001b[0m \u001b[38;5;141m\(.repository.fullName)\u001b[0m ➜ \u001b[38;5;84m\(.commit.message)\u001b[0m"'
