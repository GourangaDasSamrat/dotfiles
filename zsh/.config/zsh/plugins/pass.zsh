#!/usr/bin/env zsh
# Function to save a local .env file into 'pass'
# Usage: env-save <file_path> <pass_storage_path>
env-save() {
	local source_file=$1
	local pass_path=$2

	# Check if the source file exists
	if [[ ! -f "$source_file" ]]; then
		_err "File '$source_file' not found."
		return 1
	fi

	# Check if a pass path was provided
	if [[ -z "$pass_path" ]]; then
		_warn "Usage: env-save <file_name> <your/custom/path>"
		return 1
	fi

	# Read file content and insert into pass (multi-line mode)
	cat "$source_file" | pass insert -m "$pass_path"

	if [[ $? -eq 0 ]]; then
		_ok "Successfully saved '$source_file' to pass as '$pass_path'"
	fi
}

# Function to load secrets from 'pass' into a local file
# Usage: env-load <pass_storage_path> [target_file_name]
env-load() {
	local pass_path=$1
	local target_file=${2:-.env} # Defaults to .env if not specified

	# Check if pass path argument is missing
	if [[ -z "$pass_path" ]]; then
		_warn "Usage: env-load <your/custom/path> [target_file_name]"
		return 1
	fi

	# Check if the pass entry actually exists before trying to load
	if ! pass "$pass_path" >/dev/null 2>&1; then
		_err "Path '$pass_path' does not exist in your password store."
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
