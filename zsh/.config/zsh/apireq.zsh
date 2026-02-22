apireq() {
	_init_colors

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
		echo "${COLOR_NORMAL}  Plain GET (no extras):${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Method${COLOR_RESET}  ${COLOR_NORMAL}→ GET${COLOR_RESET}"
		echo "${COLOR_CURSOR}    URL${COLOR_RESET}     ${COLOR_NORMAL}→ http://localhost:4000/api/v1/products${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Options${COLOR_RESET} ${COLOR_NORMAL}→ None${COLOR_RESET}"
		echo ""
		echo "${COLOR_NORMAL}  File upload (Multipart):${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Method${COLOR_RESET}  ${COLOR_NORMAL}→ POST${COLOR_RESET}"
		echo "${COLOR_CURSOR}    URL${COLOR_RESET}     ${COLOR_NORMAL}→ http://localhost:4000/api/v1/upload${COLOR_RESET}"
		echo "${COLOR_CURSOR}    Body${COLOR_RESET}    ${COLOR_NORMAL}→ Multipart → file=@/home/user/photo.jpg${COLOR_RESET}"
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

	#  Method
	echo "${COLOR_HEADER}▶ HTTP Method:${COLOR_RESET}"
	local method
	method=$(printf '%s\n' "GET" "POST" "PUT" "PATCH" "DELETE" "HEAD" "OPTIONS" | _fzf_pick)
	[[ -z "$method" ]] && echo "${COLOR_ERROR}✗ Cancelled${COLOR_RESET}" && return 1
	echo "${COLOR_SUCCESS}  ✓ Method: ${COLOR_TEXT}$method${COLOR_RESET}"
	echo ""

	#  URL
	echo "${COLOR_HEADER}▶ Request URL:${COLOR_RESET}"
	echo -n "${COLOR_CURSOR}  URL › ${COLOR_RESET}"
	local url
	read -r url
	[[ -z "$url" ]] && echo "${COLOR_ERROR}✗ URL cannot be empty${COLOR_RESET}" && return 1
	echo ""

	#  What to include
	echo "${COLOR_HEADER}▶ What would you like to include?${COLOR_RESET}"
	local selections
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
	local -a extra_headers=()

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
	local -a curl_body_args=()
	local -a content_type_header=()

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
			local json_body
			json_body=$(cat)
			if echo "$json_body" | python3 -m json.tool &>/dev/null; then
				echo "${COLOR_SUCCESS}  ✓ Valid JSON${COLOR_RESET}"
			else
				echo "${COLOR_WARNING}  ⚠ Invalid JSON, sending as-is${COLOR_RESET}"
			fi
			curl_body_args+=(-d "$json_body")
			;;
		"Raw Text")
			content_type_header=(-H "Content-Type: text/plain")
			echo "${COLOR_HEADER}▶ Raw Text Body:${COLOR_RESET}"
			echo "${COLOR_NORMAL}  Ctrl+D when done${COLOR_RESET}"
			local raw_body
			raw_body=$(cat)
			curl_body_args+=(-d "$raw_body")
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
			curl_body_args+=(-d "$form_data")
			echo "${COLOR_SUCCESS}  ✓ Form data set${COLOR_RESET}"
			;;
		"Multipart Form Data")
			echo "${COLOR_HEADER}▶ Multipart Fields:${COLOR_RESET}"
			echo "${COLOR_NORMAL}  key=value or key=@/path/to/file, Ctrl+D when done${COLOR_RESET}"
			local -a multipart_args=()
			while IFS= read -r line; do
				[[ -z "$line" ]] && continue
				multipart_args+=(-F "$line")
			done
			curl_body_args+=("${multipart_args[@]}")
			echo "${COLOR_SUCCESS}  ✓ Multipart data set${COLOR_RESET}"
			;;
		esac
		echo ""
	fi

	#  Output Format
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
}
