#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TEST_HOME="$(mktemp -d)"
FAKE_BIN="$TEST_HOME/bin"
CLIPBOARD_FILE="$TEST_HOME/clipboard.txt"
mkdir -p "$FAKE_BIN"

cleanup() {
  rm -rf "$TEST_HOME"
}
trap cleanup EXIT

cat > "$FAKE_BIN/wl-copy" <<EOF
#!/usr/bin/env bash
cat > "$CLIPBOARD_FILE"
EOF
chmod +x "$FAKE_BIN/wl-copy"

export HOME="$TEST_HOME"
export PATH="$FAKE_BIN:$PATH"

# shellcheck source=/dev/null
source "$PROJECT_ROOT/ld.sh"

ld start
echo "hello from smoke test"
ld stop
ld c

if [ ! -f "$CLIPBOARD_FILE" ]; then
  echo "clipboard file was not created"
  exit 1
fi

if ! grep -q "hello from smoke test" "$CLIPBOARD_FILE"; then
  echo "expected output not found in clipboard payload"
  exit 1
fi

echo "smoke test passed"
