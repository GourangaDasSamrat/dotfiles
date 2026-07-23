#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_dates.sh"
set_range "${1:?usage: run-summary.sh <month|year|last-month|last-year>}"

gh api graphql -F query=@"$DIR/../graphql/queries/summary.graphql" -F from="$FROM" -F to="$TO" \
  | jq -r --arg label "$LABEL" -f "$DIR/../graphql/filters/summary.jq"
