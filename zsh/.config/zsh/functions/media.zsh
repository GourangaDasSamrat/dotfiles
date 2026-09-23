#!/usr/bin/env zsh
# yt [options] <url> [height] [index] — streams video/playlist URLs via mpv & yt-dlp
# Flags: -q <height> (144..2160), -n <index> (playlist start index), -a (audio-only), -f (fullscreen)
# Auto-detects positional height and playlist index without flags
if (( $+commands[mpv] )) && (( $+commands[yt-dlp] )); then
    yt() {
        local -A opts
        # Parse flags: -q (quality/height), -n (playlist start index), -a (audio-only), -f (fullscreen)
        zparseopts -D -E -A opts q: n: a f

        local height="${opts[-q]:-480}"
        local num="${opts[-n]:-}"
        local url=""

        # Process positional arguments
        for arg in "$@"; do
            if [[ "$arg" == <-> ]]; then
                # Categorize numeric inputs into resolution presets or playlist index
                if [[ "$arg" =~ ^(144|240|360|480|720|1080|1440|2160)$ ]]; then
                    height="$arg"
                else
                    num="$arg"
                fi
            else
                url="$arg"
            fi
        done

        if [[ -z "$url" ]]; then
            _err "No target URL provided." >&2
            echo "${COLOR_HEADER}Usage:${COLOR_RESET} ${COLOR_TEXT}yt${COLOR_RESET} [${COLOR_NORMAL}-q height${COLOR_RESET}] [${COLOR_NORMAL}-n start_num${COLOR_RESET}] [${COLOR_NORMAL}-a${COLOR_RESET}] [${COLOR_NORMAL}-f${COLOR_RESET}] ${COLOR_CURSOR}<URL>${COLOR_RESET}" >&2
            return 1
        fi

        # Build yt-dlp raw option string for playlists
        local raw_opts="yes-playlist="
        [[ -n "$num" ]] && raw_opts="yes-playlist=,playlist-start=$num"

        # Define media format string based on flags
        local format="bestvideo[height<=${height}][vcodec^=avc1]+bestaudio/best"
        (( ${+opts[-a]} )) && format="bestaudio/best"

        # Check for fullscreen flag
        local -a extra_flags=()
        (( ${+opts[-f]} )) && extra_flags+=(--fullscreen)

        # Execute mpv playback
        mpv --profile=fast \
            --framedrop=vo \
            "${extra_flags[@]}" \
            --ytdl-format="$format" \
            --ytdl-raw-options="$raw_opts" \
            "$url"
    }
fi

