#!/bin/bash

# Structure and functionality checks for everything under scripts/.
# Used by .github/workflows/scripts-functionality.yml.
#
#   1. every script passes `bash -n`
#   2. every script in lib/ and utils/ can be sourced silently (no side effects)
#   3. the package lists are well formed for every supported package manager
#   4. the Fedora COPR step calls dnf as expected (dnf is stubbed)
#
# All checks run even when an earlier one fails. Failures are printed, and when
# GITHUB_OUTPUT is set they are exported as FAILED_SCRIPTS for the issue step.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT" || exit 1

failures=()

fail() {
  echo "  FAIL  $1"
  failures+=("$1")
}

# ── 1. Syntax ─────────────────────────────────────────────────────────────────
echo "[1/4] Syntax check (bash -n)"
mapfile -d '' -t all_scripts < <(find scripts -type f -name "*.sh" -print0 | sort -z)

for script in "${all_scripts[@]}"; do
  if bash -n "$script"; then
    echo "  ok    $script"
  else
    fail "$script (syntax error)"
  fi
done

# ── 2. Sourcing ───────────────────────────────────────────────────────────────
# lib/ and utils/ are meant to be sourced, so sourcing them has to define
# functions only: no output, no installs, no downloads.
echo ""
echo "[2/4] Sourcing lib/ and utils/ scripts"
for script in "${all_scripts[@]}"; do
  case "$script" in
  scripts/lib/* | scripts/utils/*) ;;
  *) continue ;;
  esac

  if ! output=$(bash -c 'source "$1"' _ "$script" 2>&1); then
    fail "$script (sourcing failed)"
  elif [ -n "$output" ]; then
    fail "$script (sourcing printed output, it has side effects)"
  else
    echo "  ok    $script"
  fi
done

# ── 3. Package lists ──────────────────────────────────────────────────────────
echo ""
echo "[3/4] Package lists"
# shellcheck source=../../scripts/lib/softwares.sh
source scripts/lib/softwares.sh

# "<OS> <package manager>" pairs _select_tools has a branch for.
for combo in "macos brew" "linux pkg" "linux dnf" "linux apt" "linux pacman"; do
  read -r OS PKG_MANAGER <<<"$combo"
  label="$OS/$PKG_MANAGER"

  TOOLS=()
  if ! _select_tools || [ "${#TOOLS[@]}" -eq 0 ]; then
    fail "$label: no packages selected"
    continue
  fi

  problems=()
  declare -A seen=()
  for tool in "${TOOLS[@]}"; do
    if [ -z "$tool" ] || [[ "$tool" =~ [[:space:]] ]]; then
      problems+=("empty or whitespace entry '$tool'")
    elif [ -n "${seen[$tool]:-}" ]; then
      problems+=("duplicate '$tool'")
    fi
    seen[$tool]=1
  done
  unset seen

  if [ "${#problems[@]}" -gt 0 ]; then
    fail "$label: ${problems[*]}"
  else
    echo "  ok    $label (${#TOOLS[@]} entries)"
  fi
done

# COPR entries are "owner/project" (or "@group/project" for group projects).
bad_copr=()
for repo in "${RHEL_COPR_REPOS[@]}"; do
  [[ "$repo" =~ ^@?[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || bad_copr+=("$repo")
done
if [ "${#bad_copr[@]}" -gt 0 ]; then
  fail "RHEL_COPR_REPOS: invalid entries: ${bad_copr[*]}"
else
  echo "  ok    RHEL_COPR_REPOS (${#RHEL_COPR_REPOS[@]} entries)"
fi

# ── 4. COPR step with a stubbed dnf ───────────────────────────────────────────
echo ""
echo "[4/4] COPR step (stubbed dnf)"
stub_dir="$(mktemp -d)"
trap 'rm -rf "$stub_dir"' EXIT

# `dnf copr` only "exists" once dnf5-plugins has been installed, like on the
# minimal Fedora image. Every call is logged so it can be asserted on.
cat >"$stub_dir/dnf" <<'STUB'
#!/bin/bash
echo "$*" >>"$DNF_LOG"
case "$1 $2" in
"copr --help") [ -f "$DNF_STATE/plugin" ] ;;
"install -y")
  [[ "$*" == *dnf5-plugins* ]] && touch "$DNF_STATE/plugin"
  exit 0
  ;;
esac
STUB
chmod +x "$stub_dir/dnf"

export DNF_LOG="$stub_dir/calls.log" DNF_STATE="$stub_dir"
: >"$DNF_LOG"

SUDO_CMD="" PATH="$stub_dir:$PATH" _enable_copr_repos >/dev/null
rc=$?

if [ "$rc" -ne 0 ]; then
  fail "COPR step: _enable_copr_repos returned $rc"
elif ! grep -qx "install -y dnf5-plugins" "$DNF_LOG"; then
  fail "COPR step: dnf copr plugin was not installed when missing"
else
  for repo in "${RHEL_COPR_REPOS[@]}"; do
    grep -qx "copr enable -y $repo" "$DNF_LOG" || fail "COPR step: $repo was not enabled"
  done
  echo "  ok    plugin installed, ${#RHEL_COPR_REPOS[@]} repo(s) enabled"
fi

# ── Result ────────────────────────────────────────────────────────────────────
echo ""
if [ "${#failures[@]}" -gt 0 ]; then
  if [ -n "${GITHUB_OUTPUT:-}" ]; then
    {
      echo "FAILED_SCRIPTS<<__FAILED_SCRIPTS_EOF__"
      printf -- '- %s\n' "${failures[@]}"
      echo "__FAILED_SCRIPTS_EOF__"
    } >>"$GITHUB_OUTPUT"
  fi
  echo "${#failures[@]} check(s) failed."
  exit 1
fi

echo "All scripts passed structure and functionality checks!"
