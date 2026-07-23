#!/usr/bin/env bash
# Sets FROM, TO, LABEL for a given period keyword.
# Usage: source _dates.sh; set_range "<period>"
set_range() {
  local period="$1"
  case "$period" in
    today)
      FROM="$(date +%Y-%m-%dT00:00:00Z)"
      TO="$(date +%Y-%m-%dT23:59:59Z)"
      LABEL="Today"
      ;;
    yesterday)
      if [[ "$OSTYPE" == "darwin"* ]]; then YD=$(date -v-1d +%Y-%m-%d); else YD=$(date -d "yesterday" +%Y-%m-%d); fi
      FROM="${YD}T00:00:00Z"
      TO="${YD}T23:59:59Z"
      LABEL="Yesterday"
      ;;
    month)
      FROM="$(date +%Y-%m-01T00:00:00Z)"
      TO="$(date +%Y-%m-%dT23:59:59Z)"
      LABEL="This Month"
      ;;
    year)
      FROM="$(date +%Y-01-01T00:00:00Z)"
      TO="$(date +%Y-%m-%dT23:59:59Z)"
      LABEL="This Year"
      ;;
    last-month)
      if [[ "$OSTYPE" == "darwin"* ]]; then
        S=$(date -v-1m +%Y-%m-01); E=$(date -v-1m -v+1m -v-1d +%Y-%m-%d)
      else
        S=$(date -d "last month" +%Y-%m-01); E=$(date -d "$S +1 month -1 day" +%Y-%m-%d)
      fi
      FROM="${S}T00:00:00Z"
      TO="${E}T23:59:59Z"
      LABEL="Last Month"
      ;;
    last-year)
      if [[ "$OSTYPE" == "darwin"* ]]; then LY=$(( $(date +%Y) - 1 )); else LY=$(date -d "last year" +%Y); fi
      FROM="${LY}-01-01T00:00:00Z"
      TO="${LY}-12-31T23:59:59Z"
      LABEL="Last Year"
      ;;
    *)
      echo "Unknown period: '$period' (expected: today|yesterday|month|year|last-month|last-year)" >&2
      exit 1
      ;;
  esac
}
