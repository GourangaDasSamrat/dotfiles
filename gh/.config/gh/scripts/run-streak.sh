#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gh api graphql -F query=@"$DIR/../graphql/queries/streak.graphql" \
  | jq -r -f "$DIR/../graphql/filters/streak.jq"
