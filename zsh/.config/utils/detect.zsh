#  Shared system helpers — OS detection & privilege resolution
#  Source this before any script that needs _os or _run

# ── OS detection ──────────────────────────────────────────────────
#   $_os  →  "mac" | "linux" | "unknown"
if [[ "$OSTYPE" == darwin* ]]; then
  _os="mac"
elif [[ "$OSTYPE" == linux* ]] || [[ -f /etc/os-release ]]; then
  _os="linux"
else
  _os="unknown"
fi

# ── Privilege resolver

if (( EUID == 0 )); then
  _priv="root"
elif command -v sudo &>/dev/null && sudo -n true 2>/dev/null; then
  _priv="sudo"
else
  _priv="none"
fi

# ── _run [cmd…]

_run() {
  case "$_priv" in
    root) command "$@" 2>/dev/null ;;
    sudo) sudo "$@"   2>/dev/null ;;
    none) return 1 ;;          # silently skip — no access
  esac
}

# ── _has_priv ─────────────────────────────────────────────────────
#   Returns 0 (true) when we have any elevated access.
#   Use in conditionals:  if _has_priv; then …; fi
_has_priv() { [[ "$_priv" == "root" || "$_priv" == "sudo" ]] }