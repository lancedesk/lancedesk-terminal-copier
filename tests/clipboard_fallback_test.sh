#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TEST_HOME="$(mktemp -d)"

cleanup() {
  rm -rf "$TEST_HOME"
}
trap cleanup EXIT

export HOME="$TEST_HOME"
# Deliberately avoid providing any supported clipboard tool in PATH.
export PATH="/usr/bin:/bin"

# shellcheck source=/dev/null
source "$PROJECT_ROOT/ld.sh"

ld start
echo "fallback test payload"
ld stop

set +e
copy_output="$(ld c 2>&1)"
copy_status=$?
set -e

if [ "$copy_status" -ne 21 ]; then
  echo "expected ld c to return 21 when clipboard tool is missing, got: $copy_status"
  echo "$copy_output"
  exit 1
fi

if ! printf '%s' "$copy_output" | grep -q "Could not find clipboard tool"; then
  echo "expected clipboard fallback message was not printed"
  echo "$copy_output"
  exit 1
fi

shown="$(ld show)"
if ! printf '%s' "$shown" | grep -q "fallback test payload"; then
  echo "expected ld show to print captured output after clipboard fallback"
  exit 1
fi

echo "clipboard fallback test passed"
