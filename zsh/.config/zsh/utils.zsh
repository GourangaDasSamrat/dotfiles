# Load helpers
[[ -z "$_os" ]] && source "${ZDOTDIR:-$HOME/.config/utils}/detect.zsh"

# Start python server with validation
serve() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  serve — Start a Python HTTP server${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    serve [port]${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    port${COLOR_RESET}    ${COLOR_NORMAL}Port number to listen on (1–65535, default: 8000)${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    serve           → starts on port 8000${COLOR_RESET}"
		echo "${COLOR_NORMAL}    serve 3000      → starts on port 3000${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  NOTES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Validates port range and checks if already in use${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Prompts for a new port if the given one is occupied${COLOR_RESET}"
		echo ""
		return 0
	fi

	local port=${1:-}

	while true; do
		if [ -z "$port" ]; then
			echo "${COLOR_HEADER}  Enter port number (default: 8000):${COLOR_RESET} "
			read port
			port=${port:-8000}
		fi

		if ! [[ "$port" =~ ^[0-9]+$ ]]; then
			echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be a number!"
			port=""
			continue
		fi

		if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
			echo "${COLOR_ERROR}  ✗${COLOR_RESET} Port must be between 1 and 65535!"
			port=""
			continue
		fi

		if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
			echo "${COLOR_WARNING}  ⚠${COLOR_RESET} Port $port is already in use!"
			echo "${COLOR_HEADER}  Try another port:${COLOR_RESET} "
			port=""
			continue
		fi

		break
	done

	echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Starting server on ${COLOR_CURSOR}http://localhost:$port${COLOR_RESET}"
	python3 -m http.server "$port"
}

# File finder with preview
ff() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  ff — Find files by name${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff <search_term>${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    search_term${COLOR_RESET}    ${COLOR_NORMAL}Filename or partial name to search for${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff config         → finds all files with 'config' in name${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff .env           → finds all .env files${COLOR_RESET}"
		echo "${COLOR_NORMAL}    ff README         → finds all README files${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  NOTES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Searches recursively from current directory${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Case-insensitive matching${COLOR_RESET}"
		echo ""
		return 0
	fi

	if [ -z "$1" ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: ff <search_term>"
		echo "${COLOR_NORMAL}    Run 'ff --help' for more info${COLOR_RESET}"
		return 1
	fi

	echo "${COLOR_HEADER}  ◆  Searching for '$1'${COLOR_RESET}"
	find . -iname "*$1*" -type f 2>/dev/null | while read file; do
		echo "    ${COLOR_SUCCESS}→${COLOR_RESET} ${COLOR_TEXT}$file${COLOR_RESET}"
	done
}

# Timer
timer() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  timer — Countdown timer${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer <duration>${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    duration${COLOR_RESET}    ${COLOR_NORMAL}Time to count down from${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  FORMAT${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Seconds only     timer 90${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Minutes          timer 5m${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Hours            timer 2h${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Combined         timer 1h30m45s${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 60          → 60 second countdown${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 5m          → 5 minute countdown${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 1h30m       → 1 hour 30 minute countdown${COLOR_RESET}"
		echo "${COLOR_NORMAL}    timer 2h15m30s    → 2h 15m 30s countdown${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  NOTES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Progress bar changes color: green → orange → red${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Desktop notification on completion (if notify-send available)${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Audio alert on completion (if paplay/aplay available)${COLOR_RESET}"
		echo "${COLOR_NORMAL}    • Press Ctrl+C to cancel${COLOR_RESET}"
		echo ""
		return 0
	fi

	local total_seconds=$1

	if [ -z "$total_seconds" ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: timer <duration>"
		echo "${COLOR_NORMAL}    Run 'timer --help' for format options${COLOR_RESET}"
		return 1
	fi

	if [[ "$total_seconds" =~ ^[0-9]+$ ]]; then
		total_seconds=$total_seconds
	else
		local parsed_seconds=0
		if [[ "$total_seconds" =~ ([0-9]+)h ]]; then
			parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]} * 3600))
		fi
		if [[ "$total_seconds" =~ ([0-9]+)m ]]; then
			parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]} * 60))
		fi
		if [[ "$total_seconds" =~ ([0-9]+)s ]]; then
			parsed_seconds=$((parsed_seconds + ${BASH_REMATCH[1]}))
		fi
		total_seconds=$parsed_seconds
	fi

	if [ $total_seconds -le 0 ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Invalid time. Run 'timer --help' for format options"
		return 1
	fi

	local remaining=$total_seconds

	tput civis
	trap 'tput cnorm; printf "\n"' EXIT INT TERM

	printf "\033[2J\033[H"

	while [ $remaining -ge 0 ]; do
		local hours=$((remaining / 3600))
		local minutes=$(((remaining % 3600) / 60))
		local seconds=$((remaining % 60))

		local progress=$((100 - (remaining * 100 / total_seconds)))
		local bar_width=40
		local filled=$((progress * bar_width / 100))
		local empty=$((bar_width - filled))

		local bar=""
		for ((i = 0; i < filled; i++)); do bar+="█"; done
		for ((i = 0; i < empty; i++)); do bar+="░"; done

		local time_color=$COLOR_SUCCESS
		if [ $remaining -le $((total_seconds / 4)) ]; then
			time_color=$COLOR_ERROR
		elif [ $remaining -le $((total_seconds / 2)) ]; then
			time_color=$COLOR_WARNING
		fi

		local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
		local spin_index=$((remaining % ${#spinner[@]}))

		printf "\033[H"
		echo
		echo "${COLOR_HEADER}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
		echo "${COLOR_HEADER}  │${COLOR_RESET}              ${COLOR_CURSOR}⏱  COUNTDOWN TIMER${COLOR_RESET}              ${COLOR_HEADER}│${COLOR_RESET}"
		echo "${COLOR_HEADER}  └─────────────────────────────────────────────┘${COLOR_RESET}"
		echo
		echo

		printf "              "
		if [ $hours -gt 0 ]; then
			printf "${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $hours $minutes $seconds
		else
			printf "    ${time_color}%02d${COLOR_NORMAL}:${time_color}%02d${COLOR_RESET}\n" $minutes $seconds
		fi
		echo
		echo

		echo "     ${COLOR_BORDER}┤${COLOR_RESET}${bar}${COLOR_BORDER}├${COLOR_RESET} ${COLOR_CURSOR}${progress}%${COLOR_RESET}"
		echo
		echo

		if [ $remaining -eq 0 ]; then
			echo "        ${COLOR_SUCCESS}✓  Time's up!${COLOR_RESET}                      "
		else
			local elapsed=$((total_seconds - remaining))
			local elapsed_m=$((elapsed / 60))
			local elapsed_s=$((elapsed % 60))
			echo "        ${spinner[$spin_index]}  Elapsed: ${COLOR_NORMAL}${elapsed_m}m ${elapsed_s}s${COLOR_RESET}              "
		fi

		echo
		echo "${COLOR_BORDER}  ─────────────────────────────────────────────${COLOR_RESET}"
		echo "        ${COLOR_NORMAL}Press Ctrl+C to cancel${COLOR_RESET}"

		[ $remaining -eq 0 ] && break

		sleep 1
		((remaining--))
	done

	printf '\a'
	command -v notify-send &>/dev/null && notify-send "Timer" "Time's up! ⏰" --urgency=critical 2>/dev/null &
	if command -v paplay &>/dev/null; then
		[ -f /usr/share/sounds/freedesktop/stereo/complete.oga ] && paplay /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null &
		[ -f /usr/share/sounds/freedesktop/stereo/bell.oga ] && paplay /usr/share/sounds/freedesktop/stereo/bell.oga &>/dev/null &
	elif command -v aplay &>/dev/null && [ -f /usr/share/sounds/alsa/Front_Center.wav ]; then
		aplay /usr/share/sounds/alsa/Front_Center.wav &>/dev/null &
	fi

	tput cnorm
	trap - EXIT INT TERM

	echo
	echo "${COLOR_SUCCESS}  ┌─────────────────────────────────────────────┐${COLOR_RESET}"
	echo "${COLOR_SUCCESS}  │${COLOR_RESET}                  ${COLOR_SUCCESS}🎉 DONE! 🎉${COLOR_RESET}                  ${COLOR_SUCCESS}│${COLOR_RESET}"
	echo "${COLOR_SUCCESS}  └─────────────────────────────────────────────┘${COLOR_RESET}"
	echo
}

# Backup file/folder with timestamp
backup() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo ""
		echo "${COLOR_HEADER}  ◆  backup — Backup a file or folder with timestamp${COLOR_RESET}"
		echo "${COLOR_BORDER}  ─────────────────────────────────────${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  USAGE${COLOR_RESET}"
		echo "${COLOR_NORMAL}    backup <file/folder>${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  ARGUMENTS${COLOR_RESET}"
		echo "${COLOR_CURSOR}    file/folder${COLOR_RESET}    ${COLOR_NORMAL}Path to the file or directory to back up${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  OUTPUT${COLOR_RESET}"
		echo "${COLOR_NORMAL}    Creates: <name>_backup_YYYYMMDD_HHMMSS.tar.gz${COLOR_RESET}"
		echo ""
		echo "${COLOR_TEXT}  EXAMPLES${COLOR_RESET}"
		echo "${COLOR_NORMAL}    backup project/          → project_backup_20240210_153045.tar.gz${COLOR_RESET}"
		echo "${COLOR_NORMAL}    backup config.json       → config.json_backup_20240210_153045.tar.gz${COLOR_RESET}"
		echo ""
		return 0
	fi

	if [ -z "$1" ]; then
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Missing argument. Usage: backup <file/folder>"
		echo "${COLOR_NORMAL}    Run 'backup --help' for more info${COLOR_RESET}"
		return 1
	fi

	local timestamp=$(date +%Y%m%d_%H%M%S)
	local backup_name="${1}_backup_${timestamp}.tar.gz"

	tar -czf "$backup_name" "$1" 2>/dev/null

	if [ $? -eq 0 ]; then
		echo "${COLOR_SUCCESS}  ✓${COLOR_RESET} Backup created: ${COLOR_CURSOR}$backup_name${COLOR_RESET}"
	else
		echo "${COLOR_ERROR}  ✗${COLOR_RESET} Backup failed!"
	fi
}

# Os cleanup
cleanup() {
  if [[ "$_os" == "unknown" ]]; then
    echo "❌  Unsupported OS: $OSTYPE"; return 1
  fi

  echo "\n🧹  Starting cleanup on $_os  (privilege: $_priv)\n"

  # ── _nuke: parallel force-delete, bypasses rm alias/function ──
  _nuke() {
    for p in "$@"; do
      command rm -rf -- "$p" 2>/dev/null &
    done
    wait
  }

  # ── _clean_cmd: run a command only when we have elevated access ─
  _clean_cmd() { _has_priv && _run "$@"; }

  echo "🔁  Common caches & build artifacts..."

  # ── Shell / misc
  _nuke \
    ~/.cache \
    ~/.local/share/Trash \
    /tmp/*(N) \
    /var/tmp/*(N) \
    ~/.thumbnails \
    ~/.zcompdump \
    ~/.zcompdump.zwc

  # ── Browsers
  _nuke \
    ~/.mozilla/firefox/*/cache2 \
    ~/.mozilla/firefox/*/thumbnails \
    ~/.config/google-chrome/Default/Cache \
    ~/.config/google-chrome/Default/Code\ Cache \
    ~/.config/chromium/Default/Cache \
    ~/.config/BraveSoftware/Brave-Browser/Default/Cache \
    ~/.config/vivaldi/Default/Cache \
    ~/.config/opera/Cache

  # ── Node / JS
  _nuke \
    ~/.npm/_cacache \
    ~/.npm/tmp \
    ~/.yarn/cache \
    **/node_modules/.cache(N)

  # ── Python ──
  _nuke \
    ~/.cache/pip \
    ~/.pip/cache \
    ~/.mypy_cache \
    ~/.pytest_cache \
    ~/.ruff_cache \
    ~/.pytype \
    ~/.hypothesis \
    ~/.tox \
    ~/.nox \
    **/__pycache__(N) \
    **/*.pyc(N) \
    **/*.pyo(N) \
    **/.pytest_cache(N) \
    **/.mypy_cache(N) \
    **/.ruff_cache(N)

  # ── Rust ────
  _nuke \
    ~/.cargo/registry/cache \
    ~/.cargo/registry/src \
    ~/.cargo/git/checkouts \
    ~/.rustup/tmp \
    ~/.rustup/toolchains/*/share/doc

  # ── Go ──────
  _nuke \
    ~/.go/pkg/mod/cache \
    ~/go/pkg/mod/cache \
    ~/.cache/go-build

  # ── Java / JVM
  _nuke \
    ~/.gradle/caches \
    ~/.gradle/daemon \
    ~/.gradle/wrapper/dists \
    ~/.m2/repository \
    ~/.ivy2/cache \
    ~/.sbt/boot \
    ~/.coursier/cache

  # ── Ruby ────
  _nuke \
    ~/.gem/cache \
    ~/.bundle/cache \
    ~/.rbenv/versions/*/lib/ruby/gems/*/cache

  # ── PHP ─────
  _nuke ~/.composer/cache

  # ── .NET ────
  _nuke \
    ~/.nuget/packages \
    ~/.dotnet/toolResolverCache

  # ── Terraform / OpenTofu
  _nuke \
    ~/.terraform.d/plugin-cache \
    ~/.cache/opentofu \
    **/.terraform(N)

  # ── Docker (user-level)
  if command -v docker &>/dev/null; then
    docker system prune -f --volumes -q 2>/dev/null &
  fi

  # ── VS Code variants  ─
  _nuke \
    ~/.vscode/extensions/.obsolete \
    ~/.vscode-server/data/logs \
    ~/.vscode-server/data/CachedExtensionVSIXs

  echo "  ✓ Common caches & artifacts"

  #  macOS SPECIFIC

  if [[ "$_os" == "mac" ]]; then
    echo "🍎  macOS caches & logs..."

    # User Library — VS Code, Code Insiders, Cursor, apps
    _nuke \
      ~/Library/Caches \
      ~/Library/Logs \
      ~/Library/Application\ Support/CrashReporter \
      ~/Library/Saved\ Application\ State \
      ~/Library/Logs/DiagnosticReports \
      "~/Library/Application Support/Code/logs" \
      "~/Library/Application Support/Code/CachedData" \
      "~/Library/Application Support/Code/Cache" \
      "~/Library/Application Support/Code/CachedExtensionVSIXs" \
      "~/Library/Application Support/Code/BackupWorkspaces" \
      "~/Library/Application Support/Code - Insiders/logs" \
      "~/Library/Application Support/Code - Insiders/CachedData" \
      "~/Library/Application Support/Code - Insiders/Cache" \
      "~/Library/Application Support/Code - Insiders/CachedExtensionVSIXs" \
      "~/Library/Application Support/cursor/logs" \
      "~/Library/Application Support/cursor/CachedData" \
      "~/Library/Application Support/cursor/Cache" \
      "~/Library/Application Support/Spotify/PersistentCache" \
      "~/Library/Application Support/zoom.us/Logs" \
      "~/Library/Application Support/Slack/Cache" \
      "~/Library/Application Support/Slack/logs" \
      "~/Library/Application Support/Discord/Cache" \
      "~/Library/Application Support/discord/Cache" \
      "~/Library/Application Support/Figma/logs" \
      "~/Library/Application Support/Postman/Cache" \
      "~/Library/Application Support/JetBrains/*/logs" \
      ~/Library/Caches/JetBrains \
      ~/Library/Caches/CocoaPods \
      ~/Library/Caches/com.apple.dt.Xcode \
      ~/Library/Caches/org.carthage.CarthageKit

    echo "  ✓ ~/Library"

    # System caches (needs privilege)
    if _has_priv; then
      _run rm -rf \
        /Library/Caches/* \
        /private/var/log/asl/*.asl \
        /private/var/log/*.gz \
        /Library/Logs/DiagnosticReports/* \
        /Library/Logs/Adobe
      echo "  ✓ /Library caches"
    fi

    # Xcode + Simulators
    _nuke \
      ~/Library/Developer/Xcode/DerivedData \
      ~/Library/Developer/Xcode/Archives \
      ~/Library/Developer/Xcode/iOS\ DeviceSupport \
      ~/Library/Developer/Xcode/watchOS\ DeviceSupport \
      ~/Library/Developer/Xcode/visionOS\ DeviceSupport \
      ~/Library/Developer/CoreSimulator/Caches \
      ~/Library/Developer/CoreSimulator/Devices/*/data/tmp \
      ~/Library/Developer/CoreSimulator/Devices/*/data/Library/Caches

    echo "  ✓ Xcode / Simulators"

    # Homebrew
    if command -v brew &>/dev/null; then
      brew cleanup --prune=all -q 2>/dev/null
      command rm -rf "$(brew --cache)" 2>/dev/null
      echo "  ✓ Homebrew"
    fi

    # CocoaPods
    _nuke ~/.cocoapods/repos ~/.cocoapods/cache

    # Docker Desktop
    _nuke \
      ~/Library/Containers/com.docker.docker/Data/log \
      ~/Library/Containers/com.docker.docker/Data/tmp

    # Flush DNS
    if _has_priv; then
      _run dscacheutil -flushcache
      _run killall -HUP mDNSResponder
      echo "  ✓ DNS cache flushed"
    fi

    # Empty Trash
    osascript -e 'tell application "Finder" to empty trash' 2>/dev/null &
    echo "  ✓ Trash emptied"

    echo "  ✓ macOS done"
  fi

  #  LINUX SPECIFIC

  if [[ "$_os" == "linux" ]]; then
    echo "🐧  Linux caches & logs..."

    # User caches — VS Code, code-oss, code-insiders, Cursor, apps
    _nuke \
      ~/.local/share/recently-used.xbel \
      ~/.recently-used \
      ~/.local/share/Trash \
      ~/.local/share/gnome-shell/extensions/.old \
      ~/.cache/thumbnails \
      ~/.cache/fontconfig \
      ~/.cache/mesa_shader_cache \
      ~/.config/Code/logs \
      ~/.config/Code/CachedData \
      ~/.config/Code/Cache \
      ~/.config/Code/CachedExtensionVSIXs \
      ~/.config/Code/BackupWorkspaces \
      ~/.config/code-oss/logs \
      ~/.config/code-oss/CachedData \
      ~/.config/code-oss/Cache \
      ~/.config/code-oss/CachedExtensionVSIXs \
      ~/.config/code-insiders/logs \
      ~/.config/code-insiders/CachedData \
      ~/.config/code-insiders/Cache \
      ~/.config/code-insiders/CachedExtensionVSIXs \
      ~/.config/cursor/logs \
      ~/.config/cursor/CachedData \
      ~/.config/cursor/Cache \
      ~/.config/Slack/Cache \
      ~/.config/Slack/logs \
      ~/.config/discord/Cache \
      ~/.config/Postman/Cache \
      ~/.local/share/JetBrains/Toolbox/logs \
      ~/.cache/JetBrains

    echo "  ✓ User caches"

    # System-level (root or sudo)
    if _has_priv; then
      # Old rotated logs
      _run find /var/log -type f \( -name "*.gz" -o -name "*.old" -o -name "*.1" \) -delete
      echo "  ✓ Old rotated logs"

      # journald
      if command -v journalctl &>/dev/null; then
        _run journalctl --vacuum-time=7d  -q
        _run journalctl --vacuum-size=100M -q
        echo "  ✓ journald vacuumed"
      fi

      # apt
      if command -v apt-get &>/dev/null; then
        _run apt-get clean     -qq
        _run apt-get autoclean -qq
        echo "  ✓ apt cache"
      fi

      # dnf / yum
      if command -v dnf &>/dev/null; then
        _run dnf clean all -q
        echo "  ✓ dnf cache"
      elif command -v yum &>/dev/null; then
        _run yum clean all -q
        echo "  ✓ yum cache"
      fi

      # pacman / paru / yay
      if command -v pacman &>/dev/null; then
        _run pacman -Sc --noconfirm -q
        echo "  ✓ pacman cache"
      fi

      # zypper (openSUSE)
      if command -v zypper &>/dev/null; then
        _run zypper clean -a -q
        echo "  ✓ zypper cache"
      fi

      # snap — remove disabled revisions
      if command -v snap &>/dev/null; then
        snap list --all 2>/dev/null \
          | awk '/disabled/{print $1, $3}' \
          | while read -r sname srev; do
              _run snap remove "$sname" --revision="$srev"
            done
        echo "  ✓ old snap revisions"
      fi
    fi

    # flatpak (no root needed)
    if command -v flatpak &>/dev/null; then
      flatpak uninstall --unused -y -q 2>/dev/null
      echo "  ✓ unused flatpak runtimes"
    fi

    echo "  ✓ Linux done"
  fi

  wait  # catch any remaining background jobs
  echo "\n✅  Cleanup complete!\n"
}