#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_FILE="$SCRIPT_DIR/ld.sh"
DEST_DIR="$HOME/.config/ld"
DEST_FILE="$DEST_DIR/ld.sh"
SOURCE_LINE='[ -f "$HOME/.config/ld/ld.sh" ] && source "$HOME/.config/ld/ld.sh"'

mkdir -p "$DEST_DIR"
cp "$SRC_FILE" "$DEST_FILE"

ensure_source_line() {
  local rc_file="$1"
  touch "$rc_file"
  if ! grep -Fq "$SOURCE_LINE" "$rc_file"; then
    printf '\n# ld terminal logger\n%s\n' "$SOURCE_LINE" >> "$rc_file"
    echo "Updated: $rc_file"
  else
    echo "Already configured: $rc_file"
  fi
}

ensure_source_line "$HOME/.bashrc"
ensure_source_line "$HOME/.zshrc"

echo ""
echo "Installed: $DEST_FILE"
echo "Open a new terminal or run: source ~/.zshrc"
echo "Usage: ld start ; <run commands> ; ld stop ; ld c"
