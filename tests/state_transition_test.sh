#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TEST_HOME="$(mktemp -d)"
FAKE_BIN="$TEST_HOME/bin"
mkdir -p "$FAKE_BIN"

cleanup() {
  rm -rf "$TEST_HOME"
}
trap cleanup EXIT

# Provide a clipboard binary so copy path remains deterministic.
cat > "$FAKE_BIN/wl-copy" <<'EOF'
#!/usr/bin/env bash
cat > /dev/null
EOF
chmod +x "$FAKE_BIN/wl-copy"

export HOME="$TEST_HOME"
export PATH="$FAKE_BIN:$PATH"

# shellcheck source=/dev/null
source "$PROJECT_ROOT/ld.sh"

set +e
ld stop >/dev/null 2>&1
status=$?
set -e
if [ "$status" -ne 11 ]; then
  echo "expected ld stop while idle to return 11, got $status"
  exit 1
fi

ld start >/dev/null
set +e
ld start >/dev/null 2>&1
status=$?
set -e
if [ "$status" -ne 10 ]; then
  echo "expected second ld start to return 10, got $status"
  exit 1
fi
ld stop >/dev/null

# Simulate interrupted/inconsistent recorder state and ensure recover works.
export LD_ACTIVE=1
unset LD_FDS_SAVED
set +e
ld stop >/dev/null 2>&1
status=$?
set -e
if [ "$status" -ne 12 ]; then
  echo "expected inconsistent stop to return 12, got $status"
  exit 1
fi

ld recover >/dev/null
status_output="$(ld status)"
if ! printf '%s' "$status_output" | grep -q "Status: idle"; then
  echo "expected ld recover to reset state to idle"
  exit 1
fi

# Simulate stale "active" state and ensure a new start auto-heals it.
export LD_ACTIVE=1
export LD_FDS_SAVED=1
set +e
ld start >/dev/null 2>&1
status=$?
set -e
if [ "$status" -ne 0 ]; then
  echo "expected ld start to auto-heal stale state, got status $status"
  exit 1
fi
ld stop >/dev/null

echo "state transition test passed"
