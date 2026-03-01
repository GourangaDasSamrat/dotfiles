apireq() {
	_init_colors

	# Ensure default save dir exists
	mkdir -p "$HOME/.apireq"

	#  Help
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}╔══════════════════════════════════════════════════════════╗${COLOR_RESET}"
		echo "${COLOR_HEADER}║              🚀  apireq  —  API Request Builder          ║${COLOR_RESET}"
		echo "${COLOR_HEADER}╚══════════════════════════════════════════════════════════╝${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}  apireq            Launch interactive API request builder${COLOR_RESET}"
		echo "${COLOR_NORMAL}  apireq --help     Show this help message${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}DESCRIPTION${COLOR_RESET}"
		echo "${COLOR_NORMAL}  An interactive curl wrapper that guides you through building${COLOR_RESET}"
		echo "${COLOR_NORMAL}  and firing HTTP requests with syntax-highlighted responses.${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}STEPS${COLOR_RESET}"
		echo "${COLOR_CURSOR}  1. HTTP Method${COLOR_RESET}     ${COLOR_NORMAL}GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS${COLOR_RESET}"
		echo "${COLOR_CURSOR}  2. URL${COLOR_RESET}             ${COLOR_NORMAL}Full request URL (e.g. http://localhost:4000/api/v1/users)${COLOR_RESET}"
		echo "${COLOR_CURSOR}  3. Options${COLOR_RESET}         ${COLOR_NORMAL}Pick what to include (multi-select with Space):${COLOR_RESET}"
		echo ""
		echo "${COLOR_NORMAL}       None           Send plain request with no extras${COLOR_RESET}"
		echo "${COLOR_NORMAL}       Auth           Bearer Token or Basic Auth${COLOR_RESET}"
		echo "${COLOR_NORMAL}       Custom Headers  Add arbitrary headers (e.g. X-API-Key: abc)${COLOR_RESET}"
		echo "${COLOR_NORMAL}       Query Params    Appended to URL as key=value pairs${COLOR_RESET}"
		echo "${COLOR_NORMAL}       Request Body    JSON / Raw Text / Form Data / Multipart${COLOR_RESET}"
		echo ""
		echo "${COLOR_CURSOR}  4. Output Format${COLOR_RESET}"
		echo ""
		echo "${COLOR_NORMAL}       bat            Full response with HTTP syntax highlighting${COLOR_RESET}"
		echo "${COLOR_NORMAL}       jq             Headers plain + body pretty-printed as JSON${COLOR_RESET}"
		echo "${COLOR_NORMAL}       auto           Headers via bat, body via jq if JSON else bat${COLOR_RESET}"
		echo "${COLOR_NORMAL}       raw            Unformatted response as-is${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}BODY TYPES${COLOR_RESET}"
		echo "${COLOR_NORMAL}  JSON               Validated via python3, sent as application/json${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Raw Text           Sent as text/plain${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Form Data          key=value pairs, sent as x-www-form-urlencoded${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Multipart          key=value or key=@/path/to/file (file upload)${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}SAVED REQUESTS${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Requests can be saved as .http files to ~/.apireq/ or any chosen folder${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Saved requests can be loaded and re-run or modified${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}  POST JSON login:${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Method${COLOR_RESET}  ${COLOR_NORMAL}→ POST${COLOR_RESET}"
		echo "${COLOR_CURSOR}    URL${COLOR_RESET}     ${COLOR_NORMAL}→ http://localhost:4000/api/v1/users/login${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Body${COLOR_RESET}    ${COLOR_NORMAL}→ JSON → {\"email\":\"test@gmail.com\",\"password\":\"12345678\"}${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Output${COLOR_RESET}  ${COLOR_NORMAL}→ auto${COLOR_RESET}"
		echo ""
		echo "${COLOR_NORMAL}  GET with Bearer token:${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Method${COLOR_RESET}  ${COLOR_NORMAL}→ GET${COLOR_RESET}"
		echo "${COLOR_CURSOR}    URL${COLOR_RESET}     ${COLOR_NORMAL}→ http://localhost:4000/api/v1/users/me${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Auth${COLOR_RESET}    ${COLOR_NORMAL}→ Bearer Token → <your_token>${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Output${COLOR_RESET}  ${COLOR_NORMAL}→ auto${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}DEPENDENCIES${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Required   curl, fzf${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Optional   bat (syntax highlight), jq (JSON format), python3 (JSON validation)${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}KEYBOARD SHORTCUTS (fzf menus)${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Space      Toggle selection (multi-select menus)${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Enter      Confirm selection${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Ctrl+C     Cancel / exit${COLOR_RESET}"
		echo "${COLOR_NORMAL}  Ctrl+D     Finish body/header input${COLOR_RESET}"
		echo ""
		return 0
	fi

	echo ""
	echo "${COLOR_HEADER}╔══════════════════════════════════╗${COLOR_RESET}"
	echo "${COLOR_HEADER}║     🚀  API Request Builder      ║${COLOR_RESET}"
	echo "${COLOR_HEADER}╚══════════════════════════════════╝${COLOR_RESET}"
	echo ""

	_fzf_pick() {
		fzf --height=40% \
			--border=rounded \
			--prompt="  › " \
			--pointer="❯" \
			--no-info
	}

	_fzf_multi() {
		fzf --height=40% \
			--border=rounded \
			--prompt="  › " \
			--pointer="❯" \
			--multi \
			--bind="space:toggle" \
			--no-info \
			--header="Space to select, Enter to confirm"
	}

	# ─── Folder picker via fzf ───────────────────────────────────────────────────
	_fzf_pick_folder() {
		local start_dir="${1:-$HOME}"
		# List dirs, skip hidden folders (any path component starting with .)
		find "$start_dir" -type d \
			-not -path '*/.*' \
			2>/dev/null \
			| sort \
			| sed "s|^$HOME|~|" \
			| fzf --height=50% \
				--border=rounded \
				--prompt="  📁 Folder › " \
				--pointer="❯" \
				--no-info \
				--header="Select folder to save (Ctrl+C = default ~/.apireq/)" \
				--preview='ls $(echo {} | sed "s|^~|'"$HOME"'|") 2>/dev/null | head -20' \
				--preview-window=right:40%
	}

	# ─── Parse .http file into variables ─────────────────────────────────────────
	_parse_http_file() {
		local file="$1"
		# Returns via globals: _HTTP_METHOD, _HTTP_URL, _HTTP_HEADERS (array), _HTTP_BODY

		_HTTP_METHOD=""
		_HTTP_URL=""
		_HTTP_HEADERS=()
		_HTTP_BODY=""

		local in_body=0
		local body_lines=()

		while IFS= read -r line || [[ -n "$line" ]]; do
			# First non-comment, non-empty line: METHOD URL
			if [[ -z "$_HTTP_METHOD" && "$line" =~ ^(GET|POST|PUT|PATCH|DELETE|HEAD|OPTIONS)[[:space:]] ]]; then
				_HTTP_METHOD=$(echo "$line" | awk '{print $1}')
				_HTTP_URL=$(echo "$line" | awk '{print $2}')
				continue
			fi
			# Headers (before blank line)
			if [[ $in_body -eq 0 && -z "$line" ]]; then
				in_body=1
				continue
			fi
			if [[ $in_body -eq 0 && "$line" =~ ^[A-Za-z0-9_-]+: ]]; then
				_HTTP_HEADERS+=("$line")
				continue
			fi
			# Body (after blank line)
			if [[ $in_body -eq 1 ]]; then
				body_lines+=("$line")
			fi
		done < "$file"

		_HTTP_BODY=$(printf '%s\n' "${body_lines[@]}")
	}

	# ─── Save request as .http file ──────────────────────────────────────────────
	_save_http_file() {
		local method="$1"
		local url="$2"
		local headers_str="$3"   # newline-separated
		local body="$4"

		echo ""
		echo "${COLOR_HEADER}▶ Save this request as .http file?${COLOR_RESET}"
		local save_choice
		save_choice=$(printf '%s\n' "Yes" "No" | _fzf_pick)
		[[ "$save_choice" != "Yes" ]] && return 0

		# File name
		echo -n "${COLOR_CURSOR}  File name (default: request.http) › ${COLOR_RESET}"
		local fname
		read -r fname
		[[ -z "$fname" ]] && fname="request.http"
		# Ensure .http extension
		[[ "$fname" != *.http ]] && fname="${fname}.http"

		# Folder picker
		echo ""
		echo "${COLOR_HEADER}▶ Choose save folder (Ctrl+C to use default ~/.apireq/):${COLOR_RESET}"
		local chosen_folder
		chosen_folder=$(_fzf_pick_folder "$HOME")

		local save_dir
		if [[ -z "$chosen_folder" ]]; then
			save_dir="$HOME/.apireq"
			echo "${COLOR_NORMAL}  → Using default: ~/.apireq/${COLOR_RESET}"
		else
			# Expand ~ back to $HOME
			save_dir=$(echo "$chosen_folder" | sed "s|^~|$HOME|")
		fi

		mkdir -p "$save_dir"
		local save_path="$save_dir/$fname"

		# Write .http file
		{
			echo "$method $url HTTP/1.1"
			# Write headers
			while IFS= read -r h; do
				[[ -n "$h" ]] && echo "$h"
			done <<< "$headers_str"
			# Blank line before body
			if [[ -n "$body" ]]; then
				echo ""
				echo "$body"
			fi
		} > "$save_path"

		echo "${COLOR_SUCCESS}  ✓ Saved to: ${COLOR_TEXT}$save_path${COLOR_RESET}"
		echo ""
	}

	# ─── Load .http file ─────────────────────────────────────────────────────────
	_load_http_file() {
		echo "${COLOR_HEADER}▶ Select .http file to load:${COLOR_RESET}"

		local chosen_file
		# Search:
		#   1. ~/.apireq/ (our dedicated dir, always included even though hidden)
		#   2. $HOME recursively but skipping hidden directories (so ~/a/test/b/c.http is found,
		#      but ~/.config/... etc are not traversed — except ~/.apireq handled above)
		chosen_file=$(
			{
				find "$HOME/.apireq" -name "*.http" -type f 2>/dev/null
				find "$HOME" -type f -name "*.http" \
					-not -path "$HOME/.apireq/*" \
					-not -path '*/.*' \
					2>/dev/null
			} \
			| sort -u \
			| fzf --height=60% \
				--border=rounded \
				--prompt="  📄 File › " \
				--pointer="❯" \
				--no-info \
				--header="Select a .http request file" \
				--preview='cat {} 2>/dev/null' \
				--preview-window=right:50%
		)

		if [[ -z "$chosen_file" ]]; then
			echo "${COLOR_ERROR}✗ No file selected${COLOR_RESET}"
			return 1
		fi

		echo "${COLOR_SUCCESS}  ✓ Loaded: ${COLOR_TEXT}$chosen_file${COLOR_RESET}"
		echo ""

		_parse_http_file "$chosen_file"

		echo "${COLOR_BORDER}────────────────────────────────────────${COLOR_RESET}"
		echo "${COLOR_WARNING}  Method : ${COLOR_TEXT}$_HTTP_METHOD${COLOR_RESET}"
		echo "${COLOR_WARNING}  URL    : ${COLOR_TEXT}$_HTTP_URL${COLOR_RESET}"
		if [[ ${#_HTTP_HEADERS[@]} -gt 0 ]]; then
			echo "${COLOR_WARNING}  Headers:${COLOR_RESET}"
			for h in "${_HTTP_HEADERS[@]}"; do
				echo "${COLOR_NORMAL}    $h${COLOR_RESET}"
			done
		fi
		if [[ -n "$_HTTP_BODY" ]]; then
			echo "${COLOR_WARNING}  Body   :${COLOR_RESET}"
			echo "${COLOR_NORMAL}$_HTTP_BODY${COLOR_RESET}"
		fi
		echo "${COLOR_BORDER}────────────────────────────────────────${COLOR_RESET}"
		echo ""

		# Ask to modify
		echo "${COLOR_HEADER}▶ Modify this request before sending?${COLOR_RESET}"
		local modify_choice
		modify_choice=$(printf '%s\n' "Yes — modify fields" "No — send as-is" | _fzf_pick)

		if [[ "$modify_choice" == "Yes — modify fields" ]]; then
			# Which fields to modify
			echo ""
			echo "${COLOR_HEADER}▶ Which fields to modify?${COLOR_RESET}"
			local mod_fields
			mod_fields=$(printf '%s\n' "Method" "URL" "Headers" "Body" | \
				fzf --height=40% \
					--border=rounded \
					--prompt="  › " \
					--pointer="❯" \
					--multi \
					--bind="space:toggle" \
					--no-info \
					--header="Space to select, Enter to confirm")

			if echo "$mod_fields" | grep -q "^Method$"; then
				echo "${COLOR_HEADER}▶ HTTP Method:${COLOR_RESET}"
				local new_method
				new_method=$(printf '%s\n' "GET" "POST" "PUT" "PATCH" "DELETE" "HEAD" "OPTIONS" | _fzf_pick)
				[[ -n "$new_method" ]] && _HTTP_METHOD="$new_method"
				echo "${COLOR_SUCCESS}  ✓ Method: ${COLOR_TEXT}$_HTTP_METHOD${COLOR_RESET}"
				echo ""
			fi

			if echo "$mod_fields" | grep -q "^URL$"; then
				echo "${COLOR_HEADER}▶ New URL:${COLOR_RESET}"
				echo -n "${COLOR_CURSOR}  URL › ${COLOR_RESET}"
				local new_url
				read -r new_url
				[[ -n "$new_url" ]] && _HTTP_URL="$new_url"
				echo ""
			fi

			if echo "$mod_fields" | grep -q "^Headers$"; then
				echo "${COLOR_HEADER}▶ Replace Headers:${COLOR_RESET}"
				echo "${COLOR_NORMAL}  One per line (e.g. Authorization: Bearer xxx), Ctrl+D when done${COLOR_RESET}"
				_HTTP_HEADERS=()
				while IFS= read -r line; do
					[[ -z "$line" ]] && continue
					_HTTP_HEADERS+=("$line")
				done
				echo "${COLOR_SUCCESS}  ✓ Headers updated${COLOR_RESET}"
				echo ""
			fi

			if echo "$mod_fields" | grep -q "^Body$"; then
				echo "${COLOR_HEADER}▶ New Body:${COLOR_RESET}"
				echo "${COLOR_NORMAL}  Enter body content, Ctrl+D when done${COLOR_RESET}"
				_HTTP_BODY=$(cat)
				echo "${COLOR_SUCCESS}  ✓ Body updated${COLOR_RESET}"
				echo ""
			fi
		fi

		return 0
	}

	# ════════════════════════════════════════════════════════════════════════════
	#  ENTRY POINT — New or Load?
	# ════════════════════════════════════════════════════════════════════════════
	echo "${COLOR_HEADER}▶ What would you like to do?${COLOR_RESET}"
	local start_choice
	start_choice=$(printf '%s\n' "Create new request" "Load saved .http file" | _fzf_pick)
	[[ -z "$start_choice" ]] && echo "${COLOR_ERROR}✗ Cancelled${COLOR_RESET}" && return 1
	echo ""

	# ─── Variables that will hold the final request ──────────────────────────────
	local method url
	local -a extra_headers=()
	local -a curl_body_args=()
	local -a content_type_header=()
	local body_content=""
	local selections=""

	if [[ "$start_choice" == "Load saved .http file" ]]; then
		# Load and optionally modify
		_load_http_file || return 1

		method="$_HTTP_METHOD"
		url="$_HTTP_URL"

		# Rebuild extra_headers from parsed headers
		for h in "${_HTTP_HEADERS[@]}"; do
			# Skip Content-Type, handled separately
			if echo "$h" | grep -qi "^content-type:"; then
				local ct_val
				ct_val=$(echo "$h" | sed 's/^[Cc]ontent-[Tt]ype:[[:space:]]*//')
				content_type_header=(-H "Content-Type: $ct_val")
			else
				extra_headers+=(-H "$h")
			fi
		done

		# Body
		if [[ -n "$_HTTP_BODY" ]]; then
			body_content="$_HTTP_BODY"
			curl_body_args+=(-d "$body_content")
		fi

	else
		# ─── CREATE NEW REQUEST ───────────────────────────────────────────────────

		#  Method
		echo "${COLOR_HEADER}▶ HTTP Method:${COLOR_RESET}"
		method=$(printf '%s\n' "GET" "POST" "PUT" "PATCH" "DELETE" "HEAD" "OPTIONS" | _fzf_pick)
		[[ -z "$method" ]] && echo "${COLOR_ERROR}✗ Cancelled${COLOR_RESET}" && return 1
		echo "${COLOR_SUCCESS}  ✓ Method: ${COLOR_TEXT}$method${COLOR_RESET}"
		echo ""

		#  URL
		echo "${COLOR_HEADER}▶ Request URL:${COLOR_RESET}"
		echo -n "${COLOR_CURSOR}  URL › ${COLOR_RESET}"
		read -r url
		[[ -z "$url" ]] && echo "${COLOR_ERROR}✗ URL cannot be empty${COLOR_RESET}" && return 1
		echo ""

		#  What to include
		echo "${COLOR_HEADER}▶ What would you like to include?${COLOR_RESET}"
		selections=$(printf '%s\n' "None" "Auth" "Custom Headers" "Query Params" "Request Body" | _fzf_multi)
		local fzf_exit=$?

		if [[ $fzf_exit -eq 130 ]]; then
			echo "${COLOR_ERROR}✗ Cancelled${COLOR_RESET}"
			return 1
		fi

		if echo "$selections" | grep -q "^None$"; then
			selections=""
		fi

		if [[ -z "$selections" ]]; then
			echo "${COLOR_NORMAL}  → Plain request, no extras${COLOR_RESET}"
		else
			echo "${COLOR_SUCCESS}  ✓ Selected: ${COLOR_TEXT}$(echo "$selections" | tr '\n' ' ')${COLOR_RESET}"
		fi
		echo ""

		#  Auth
		if echo "$selections" | grep -q "^Auth$"; then
			echo "${COLOR_HEADER}▶ Auth Type:${COLOR_RESET}"
			local auth_type
			auth_type=$(printf '%s\n' "Bearer Token" "Basic Auth" | _fzf_pick)

			case "$auth_type" in
			"Bearer Token")
				echo -n "${COLOR_CURSOR}  Token › ${COLOR_RESET}"
				local token
				read -r token
				extra_headers+=(-H "Authorization: Bearer $token")
				echo "${COLOR_SUCCESS}  ✓ Bearer token added${COLOR_RESET}"
				;;
			"Basic Auth")
				echo -n "${COLOR_CURSOR}  Username › ${COLOR_RESET}"
				local buser
				read -r buser
				echo -n "${COLOR_CURSOR}  Password › ${COLOR_RESET}"
				local bpass
				read -rs bpass
				echo ""
				extra_headers+=(-u "$buser:$bpass")
				echo "${COLOR_SUCCESS}  ✓ Basic auth added${COLOR_RESET}"
				;;
			esac
			echo ""
		fi

		#  Custom Headers
		if echo "$selections" | grep -q "^Custom Headers$"; then
			echo "${COLOR_HEADER}▶ Custom Headers:${COLOR_RESET}"
			echo "${COLOR_NORMAL}  One per line (e.g. X-API-Key: abc123), Ctrl+D when done${COLOR_RESET}"
			while IFS= read -r line; do
				[[ -z "$line" ]] && continue
				extra_headers+=(-H "$line")
			done
			echo "${COLOR_SUCCESS}  ✓ Custom headers added${COLOR_RESET}"
			echo ""
		fi

		#  Query Params
		if echo "$selections" | grep -q "^Query Params$"; then
			echo "${COLOR_HEADER}▶ Query Params:${COLOR_RESET}"
			echo "${COLOR_NORMAL}  One key=value per line, Ctrl+D when done${COLOR_RESET}"
			local param_string=""
			while IFS= read -r line; do
				[[ -z "$line" ]] && continue
				param_string+="${param_string:+&}$line"
			done
			[[ -n "$param_string" ]] && url="${url}?${param_string}"
			echo "${COLOR_SUCCESS}  ✓ Params appended${COLOR_RESET}"
			echo ""
		fi

		#  Body
		if echo "$selections" | grep -q "^Request Body$"; then
			echo "${COLOR_HEADER}▶ Body Type:${COLOR_RESET}"
			local body_type
			body_type=$(printf '%s\n' "JSON" "Raw Text" "Form Data (x-www-form-urlencoded)" "Multipart Form Data" | _fzf_pick)
			echo ""

			case "$body_type" in
			"JSON")
				content_type_header=(-H "Content-Type: application/json")
				echo "${COLOR_HEADER}▶ JSON Body:${COLOR_RESET}"
				echo "${COLOR_NORMAL}  Enter JSON, Ctrl+D when done${COLOR_RESET}"
				body_content=$(cat)
				if echo "$body_content" | python3 -m json.tool &>/dev/null; then
					echo "${COLOR_SUCCESS}  ✓ Valid JSON${COLOR_RESET}"
				else
					echo "${COLOR_WARNING}  ⚠ Invalid JSON, sending as-is${COLOR_RESET}"
				fi
				curl_body_args+=(-d "$body_content")
				;;
			"Raw Text")
				content_type_header=(-H "Content-Type: text/plain")
				echo "${COLOR_HEADER}▶ Raw Text Body:${COLOR_RESET}"
				echo "${COLOR_NORMAL}  Ctrl+D when done${COLOR_RESET}"
				body_content=$(cat)
				curl_body_args+=(-d "$body_content")
				echo "${COLOR_SUCCESS}  ✓ Text body set${COLOR_RESET}"
				;;
			"Form Data (x-www-form-urlencoded)")
				content_type_header=(-H "Content-Type: application/x-www-form-urlencoded")
				echo "${COLOR_HEADER}▶ Form Fields:${COLOR_RESET}"
				echo "${COLOR_NORMAL}  One key=value per line, Ctrl+D when done${COLOR_RESET}"
				local form_data=""
				while IFS= read -r line; do
					[[ -z "$line" ]] && continue
					form_data+="${form_data:+&}$line"
				done
				body_content="$form_data"
				curl_body_args+=(-d "$body_content")
				echo "${COLOR_SUCCESS}  ✓ Form data set${COLOR_RESET}"
				;;
			"Multipart Form Data")
				echo "${COLOR_HEADER}▶ Multipart Fields:${COLOR_RESET}"
				echo "${COLOR_NORMAL}  key=value or key=@/path/to/file, Ctrl+D when done${COLOR_RESET}"
				local -a multipart_args=()
				while IFS= read -r line; do
					[[ -z "$line" ]] && continue
					multipart_args+=(-F "$line")
					body_content+="$line "
				done
				curl_body_args+=("${multipart_args[@]}")
				echo "${COLOR_SUCCESS}  ✓ Multipart data set${COLOR_RESET}"
				;;
			esac
			echo ""
		fi
	fi  # end create new / load

	# ─── Output Format ────────────────────────────────────────────────────────────
	echo "${COLOR_HEADER}▶ Output Format:${COLOR_RESET}"
	local output_fmt
	output_fmt=$(printf '%s\n' "auto (bat + jq)" "bat (syntax highlight)" "jq (JSON only)" "raw" | _fzf_pick)
	[[ -z "$output_fmt" ]] && echo "${COLOR_ERROR}✗ Cancelled${COLOR_RESET}" && return 1
	echo ""

	#  Show Command
	echo "${COLOR_BORDER}────────────────────────────────────────${COLOR_RESET}"
	echo "${COLOR_WARNING}▶ Executing:${COLOR_RESET}"
	echo "${COLOR_NORMAL}  curl -s -i -X $method${COLOR_RESET}"
	[[ ${#content_type_header[@]} -gt 0 ]] && echo "${COLOR_NORMAL}    ${content_type_header[*]}${COLOR_RESET}"
	for h in "${extra_headers[@]}"; do echo "${COLOR_NORMAL}    $h${COLOR_RESET}"; done
	[[ ${#curl_body_args[@]} -gt 0 ]] && echo "${COLOR_NORMAL}    ${curl_body_args[*]}${COLOR_RESET}"
	echo "${COLOR_NORMAL}    \"$url\"${COLOR_RESET}"
	echo "${COLOR_BORDER}────────────────────────────────────────${COLOR_RESET}"
	echo ""

	#  Fire!
	local response
	response=$(curl -s -i -X "$method" \
		"${content_type_header[@]}" \
		"${extra_headers[@]}" \
		"${curl_body_args[@]}" \
		"$url")

	local curl_exit=$?
	if [[ $curl_exit -ne 0 ]]; then
		echo "${COLOR_ERROR}✗ curl failed (exit $curl_exit)${COLOR_RESET}"
		return 1
	fi

	echo "${COLOR_SUCCESS}✓ Response:${COLOR_RESET}"
	echo ""

	case "$output_fmt" in
	"auto (bat + jq)")
		local headers body content_type
		headers=$(echo "$response" | sed '/^\r\?$/q')
		body=$(echo "$response" | sed '1,/^\r\?$/d')
		content_type=$(echo "$headers" | grep -i "content-type:" | head -1)

		echo "$headers" | bat -l http --style=numbers,grid

		echo ""

		if echo "$content_type" | grep -qi "application/json"; then
			echo "${COLOR_HEADER}▶ Body (jq):${COLOR_RESET}"
			echo "$body" | jq .
		else
			echo "${COLOR_HEADER}▶ Body (bat):${COLOR_RESET}"
			echo "$body" | bat --style=numbers,grid
		fi
		;;
	"bat (syntax highlight)")
		echo "$response" | sed '1,/^\r$/! s/^{/{\n/g' | bat -l http --style=numbers,grid
		;;
	"jq (JSON only)")
		echo "$response" | sed '/^\r\?$/q'
		echo ""
		echo "$response" | sed '1,/^\r\?$/d' | jq .
		;;
	*)
		echo "$response"
		;;
	esac

	# ─── Save prompt ──────────────────────────────────────────────────────────────
	# Build a headers string for saving
	local save_headers_str=""
	# Content-Type header
	if [[ ${#content_type_header[@]} -gt 0 ]]; then
		# Extract just the value after -H
		local ct
		ct=$(echo "${content_type_header[*]}" | sed 's/-H //')
		# Remove surrounding quotes if any
		ct=$(echo "$ct" | tr -d '"')
		save_headers_str+="$ct"$'\n'
	fi
	# Extra headers (strip the -H flag and -u flag entries)
	local skip_next=0
	for h in "${extra_headers[@]}"; do
		if [[ "$skip_next" -eq 1 ]]; then
			# This is the value after -u
			save_headers_str+="X-Basic-Auth: $h"$'\n'
			skip_next=0
			continue
		fi
		if [[ "$h" == "-H" ]]; then
			continue
		fi
		if [[ "$h" == "-u" ]]; then
			skip_next=1
			continue
		fi
		# Strip leading -H if bundled
		h=$(echo "$h" | sed 's/^-H //')
		save_headers_str+="$h"$'\n'
	done

	_save_http_file "$method" "$url" "$save_headers_str" "$body_content"
}