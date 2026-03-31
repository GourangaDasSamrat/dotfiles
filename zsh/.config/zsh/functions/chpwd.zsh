# First, load the hook function (important)
autoload -Uz add-zsh-hook

# --- Function 1: Handle Python Virtual Environments ---
_manage_python_venv() {
  # Common environment folder names
  local venv_names=(".venv" "venv" ".env")
  local found_venv=""

  for venv in "${venv_names[@]}"; do
    if [[ -d "$venv" ]]; then
      found_venv="$PWD/$venv"
      break
    fi
  done

  if [[ -n "$found_venv" ]]; then
    if [[ "$VIRTUAL_ENV" != "$found_venv" ]]; then
      [[ -n "$VIRTUAL_ENV" ]] && deactivate
      source "$found_venv/bin/activate"
    fi
  elif [[ -n "$VIRTUAL_ENV" ]]; then
    deactivate
  fi
}

# --- Function 2: List Project Automation Tools ---
_list_project_tools() {
  # 1. Justfile Support
  if [[ -f "justfile" ]] && command -v just &>/dev/null; then
    echo -e "\n\033[1;34m⚡ Justfile detected:\033[0m"
    just --list

  # 2. Makefile Support
  elif [[ -f "Makefile" ]] && command -v make &>/dev/null; then
    echo -e "\n\033[1;32m🛠️  Makefile detected:\033[0m"
    make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /); print A[1]}' | sort -u

  # 3. NPM / package.json Support
  elif [[ -f "package.json" ]] && command -v jq &>/dev/null; then
    echo -e "\n\033[1;33m📦 NPM Scripts detected:\033[0m"
    jq -r '.scripts | keys[]' package.json 2>/dev/null
  fi

  # 4. Docker Compose Support
  if [[ -f "docker-compose.yml" || -f "docker-compose.yaml" || -f "compose.yaml" ]]; then
    if command -v docker &>/dev/null; then
      echo -e "\n\033[1;36m🐳 Docker Compose detected:\033[0m"
      docker compose ps --services 2>/dev/null
    fi
  fi
}

# --- Function 3: Nvm auto switch
_auto_nvm_use() {
  if [[ -f ".nvmrc" && -r ".nvmrc" ]]; then
    nvm use
  fi
}

# --- Register functions to run on directory change ---
add-zsh-hook chpwd _manage_python_venv
add-zsh-hook chpwd _list_project_tools
add-zsh-hook chpwd _auto_nvm_use
