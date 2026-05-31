# Ask questions directly from the terminal using Google Gemini AI.
# Requires: curl, jq, python3, pass.
# Save your Gemini API key with: pass insert apps/key/gemini
# Usage: ask what is docker  |  ask "explain recursion simply"
if command -v curl &>/dev/null && command -v jq &>/dev/null && command -v pass &>/dev/null && command -v python3 &>/dev/null; then
  ask() {
    if [[ $# -eq 0 ]]; then
      echo "${COLOR_ERROR}Usage: ask <your question>${COLOR_RESET}"
      return 1
    fi

    local question="$*"
    local api_key

    api_key=$(pass apps/key/gemini 2>/dev/null)
    if [[ -z "$api_key" ]]; then
      echo "${COLOR_ERROR}✗ Failed to retrieve API key${COLOR_RESET}"
      return 1
    fi

    echo "${COLOR_HEADER} Asking Gemini...${COLOR_RESET}"

    local answer
    answer=$(curl -sf "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent" \
      -H "x-goog-api-key: $api_key" \
      -H "Content-Type: application/json" \
      -X POST \
      -d "{\"contents\":[{\"parts\":[{\"text\":$(echo "$question" | jq -Rs .)}]}]}" \
      | python3 -c "
import sys, json
data = json.load(sys.stdin)
parts = data['candidates'][0]['content']['parts']
print(''.join(p['text'] for p in parts if 'text' in p))
")

    if [[ -z "$answer" ]]; then
      echo "${COLOR_ERROR}✗ Could not parse response${COLOR_RESET}"
      return 1
    fi

    echo "${COLOR_CURSOR}╭─ Answer${COLOR_RESET}"
    echo "$answer" | while IFS= read -r line; do
      echo "${COLOR_CURSOR}│${COLOR_RESET} ${COLOR_TEXT}$line${COLOR_RESET}"
    done
    echo "${COLOR_CURSOR}╰─${COLOR_RESET}"
  }
fi
