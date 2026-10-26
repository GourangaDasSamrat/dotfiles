#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_dates.sh"

period="${1:?usage: commits-day.sh <today|yesterday>}"
require_day_period "$period" "commits-day.sh"
set_range "$period"

gh search commits --author="@me" --committer-date="${FROM%%T*}" --json "repository,commit" \
  | jq -r -f "$DIR/../graphql/filters/commits-day.jq"
