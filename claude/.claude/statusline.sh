#!/usr/bin/env bash

input=$(cat)

# ---------- Dracula palette (24-bit truecolor) ----------
COMMENT=$'\033[38;2;98;114;164m'
CYAN=$'\033[38;2;139;233;253m'
GREEN=$'\033[38;2;80;250;123m'
ORANGE=$'\033[38;2;255;184;108m'
PINK=$'\033[38;2;255;121;198m'
PURPLE=$'\033[38;2;189;147;249m'
RED=$'\033[38;2;255;85;85m'
YELLOW=$'\033[38;2;241;250;140m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

# ---------- Nerd Font glyphs ----------
# Written as raw UTF-8 byte escapes (\xHH) rather than \uXXXX so they
# render correctly regardless of the shell's locale settings.
ICO_MODEL=$'\xef\x8b\x9b'      #  nf-fa-microchip
ICO_DIR=$'\xef\x81\xbc'        #  nf-fa-folder_open
ICO_BRANCH=$'\xef\x90\x98'     #  nf-oct-git_branch
ICO_ADD=$'\xef\x81\x95'        #  nf-fa-plus_circle   (staged)
ICO_MOD=$'\xef\x81\x80'        #  nf-fa-pencil        (modified)
ICO_CTX=$'\xef\x87\x80'        #  nf-fa-database      (context window)
ICO_COST=$'\xef\x85\x95'       #  nf-fa-dollar
ICO_CLOCK=$'\xef\x80\x97'      #  nf-fa-clock_o
ICO_BOLT=$'\xef\x83\xa7'       #  nf-fa-bolt          (fast mode)
ICO_BRAIN=$'\xef\x83\xab'      #  nf-fa-lightbulb_o   (effort/thinking)
ICO_HOURGLASS=$'\xef\x89\x92'  #  nf-fa-hourglass_half (rate limit)
BLOCK_FULL=$'\xe2\x96\x88'     # █ (filled bar segment)
BLOCK_LIGHT=$'\xe2\x96\x91'    # ░ (empty bar segment)

SEP="${COMMENT} \xe2\x94\x82 ${RESET}"   # │ separator

# ---------- Parse session JSON ----------
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
DIRNAME="${DIR##*/}"
[ -z "$DIRNAME" ] && DIRNAME="~"

PCT_RAW=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
PCT=$(printf '%.0f' "$PCT_RAW" 2>/dev/null)
[ -z "$PCT" ] && PCT=0

COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DUR_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
EFFORT=$(echo "$input" | jq -r '.effort.level // empty')
FAST=$(echo "$input" | jq -r '.fast_mode // false')
SESSION_ID=$(echo "$input" | jq -r '.session_id // "nosession"')
FIVEH=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

# ---------- Git info, cached 5s so the status line stays snappy ----------
CACHE_FILE="/tmp/statusline-git-${SESSION_ID}"
BRANCH=""; STAGED=0; MODIFIED=0

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] && return 0
  local age=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
  [ "$age" -gt 5 ]
}

if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
  if cache_is_stale; then
    B=$(git -C "$DIR" branch --show-current 2>/dev/null)
    S=$(git -C "$DIR" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    M=$(git -C "$DIR" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    echo "${B}|${S}|${M}" > "$CACHE_FILE"
  fi
  IFS='|' read -r BRANCH STAGED MODIFIED < "$CACHE_FILE"
fi

# ---------- Context-window progress bar ----------
BAR_WIDTH=12
FILLED=$(( PCT * BAR_WIDTH / 100 ))
[ "$FILLED" -gt "$BAR_WIDTH" ] && FILLED=$BAR_WIDTH
EMPTY=$(( BAR_WIDTH - FILLED ))

if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /$BLOCK_FULL}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /$BLOCK_LIGHT}"

# ---------- Cost & duration ----------
COST_FMT=$(printf '$%.2f' "$COST")
DUR_SEC=$(( DUR_MS / 1000 ))
MINS=$(( DUR_SEC / 60 ))
SECS=$(( DUR_SEC % 60 ))

# ---------- Line 1: model · directory · git ----------
LINE1="${BOLD}${PURPLE}${ICO_MODEL} ${MODEL}${RESET}${SEP}${CYAN}${ICO_DIR} ${DIRNAME}${RESET}"

if [ -n "$BRANCH" ]; then
  GIT_SEG="${GREEN}${ICO_BRANCH} ${BRANCH}${RESET}"
  { [ "$STAGED" -gt 0 ]; } 2>/dev/null && GIT_SEG="${GIT_SEG} ${GREEN}${ICO_ADD}${STAGED}${RESET}"
  { [ "$MODIFIED" -gt 0 ]; } 2>/dev/null && GIT_SEG="${GIT_SEG} ${ORANGE}${ICO_MOD}${MODIFIED}${RESET}"
  LINE1="${LINE1}${SEP}${GIT_SEG}"
fi

[ "$FAST" = "true" ] && LINE1="${LINE1} ${YELLOW}${ICO_BOLT}${RESET}"
[ -n "$EFFORT" ] && LINE1="${LINE1} ${PINK}${ICO_BRAIN}${EFFORT}${RESET}"

# ---------- Line 2: context bar · cost · duration · rate limit ----------
LINE2="${BAR_COLOR}${ICO_CTX} ${BAR}${RESET} ${BAR_COLOR}${PCT}%${RESET}${SEP}${YELLOW}${ICO_COST} ${COST_FMT}${RESET}${SEP}${COMMENT}${ICO_CLOCK} ${MINS}m ${SECS}s${RESET}"

if [ -n "$FIVEH" ]; then
  FIVEH_R=$(printf '%.0f' "$FIVEH" 2>/dev/null)
  LINE2="${LINE2}${SEP}${PURPLE}${ICO_HOURGLASS} 5h:${FIVEH_R}%${RESET}"
fi

printf '%b\n%b\n' "$LINE1" "$LINE2"
