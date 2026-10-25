#!/bin/bash

# Runs scripts/lib/softwares.sh and then verifies the result with
# verify-software.sh. Exits non-zero if EITHER of the two failed.
#
# Shared by every job in .github/workflows/software-install-test.yml
# (linux containers, macOS, Termux), so the install/verify sequence is
# defined in exactly one place.
#
# softwares.sh keeps going when a single package fails, so both exit codes are
# collected before deciding on the final status.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

bash "$REPO_ROOT/scripts/lib/softwares.sh"
install_status=$?

bash "$REPO_ROOT/.github/scripts/verify-software.sh"
verify_status=$?

echo "install exit code: $install_status, verify exit code: $verify_status"
[ "$install_status" -eq 0 ] && [ "$verify_status" -eq 0 ]
