# Function to save a local .env file into 'pass'
# Usage: env-save <file_path> <pass_storage_path>
env-save() {
  local source_file=$1
  local pass_path=$2

  # Check if the source file exists
  if [[ ! -f "$source_file" ]]; then
    echo "${COLOR_ERROR}❌ Error: File '$source_file' not found.${COLOR_RESET}"
    return 1
  fi

  # Check if a pass path was provided
  if [[ -z "$pass_path" ]]; then
    echo "${COLOR_WARNING}Usage: env-save <file_name> <your/custom/path>${COLOR_RESET}"
    return 1
  fi

  # Read file content and insert into pass (multi-line mode)
  cat "$source_file" | pass insert -m "$pass_path"

  if [[ $? -eq 0 ]]; then
    echo "${COLOR_SUCCESS}✅ Successfully saved '$source_file' to pass as '$pass_path'${COLOR_RESET}"
  fi
}

# Function to load secrets from 'pass' into a local file
# Usage: env-load <pass_storage_path> [target_file_name]
env-load() {
  local pass_path=$1
  local target_file=${2:-.env} # Defaults to .env if not specified

  # Check if pass path argument is missing
  if [[ -z "$pass_path" ]]; then
    echo "${COLOR_WARNING}Usage: env-load <your/custom/path> [target_file_name]${COLOR_RESET}"
    return 1
  fi

  # Check if the pass entry actually exists before trying to load
  if ! pass "$pass_path" >/dev/null 2>&1; then
    echo "${COLOR_ERROR}❌ Error: Path '$pass_path' does not exist in your password store.${COLOR_RESET}"
    return 1
  fi

  # Export content from pass to the target file
  pass "$pass_path" >"$target_file"

  if [[ $? -eq 0 ]]; then
    # Showing line count for confirmation (useful for 20-25 variables)
    local line_count=$(wc -l <"$target_file")
    echo "${COLOR_HEADER}🚀 Loaded '$pass_path' into '$target_file' ($line_count lines)${COLOR_RESET}"
  fi
}
