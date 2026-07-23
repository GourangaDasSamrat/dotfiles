#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_dates.sh"
set_range "${1:?usage: run-languages.sh <year|last-year>}"

gh api graphql -F query=@"$DIR/../graphql/queries/languages.graphql" -F from="$FROM" -F to="$TO" \
  | jq -r -f "$DIR/../graphql/filters/languages.jq"
