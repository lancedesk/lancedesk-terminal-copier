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

sample_log="$TEST_HOME/sample.log"
printf '%b\n' '\033=\033> \033]633;D;0\ahello \033[31mred\033[0m world' > "$sample_log"

ld c "$sample_log" >/dev/null
clean_payload="$(cat "$CLIPBOARD_FILE")"
if printf '%s' "$clean_payload" | grep -q $'\033'; then
  echo "expected clean copy without escape codes"
  exit 1
fi
if printf '%s' "$clean_payload" | grep -Eq '[\x00-\x08\x0B-\x1F\x7F]'; then
  echo "expected clean copy without control bytes"
  exit 1
fi
if ! printf '%s' "$clean_payload" | grep -Eq 'hello[[:space:]]+red[[:space:]]+world'; then
  echo "expected sanitized payload content not found"
  printf 'clean payload:\n%s\n' "$clean_payload"
  exit 1
fi

ld c --raw "$sample_log" >/dev/null
raw_payload="$(cat "$CLIPBOARD_FILE")"
if ! printf '%s' "$raw_payload" | grep -q $'\033'; then
  echo "expected raw copy to preserve escape codes"
  exit 1
fi

show_clean="$(ld show --clean "$sample_log")"
if printf '%s' "$show_clean" | grep -q $'\033'; then
  echo "expected ld show --clean to remove escape codes"
  exit 1
fi

echo "sanitize copy test passed"
