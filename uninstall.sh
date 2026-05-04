#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="$HOME/.config/ld"
DEST_FILE="$DEST_DIR/ld.sh"
SOURCE_LINE='[ -f "$HOME/.config/ld/ld.sh" ] && source "$HOME/.config/ld/ld.sh"'

remove_source_line() {
  local rc_file="$1"
  [ -f "$rc_file" ] || return 0

  if grep -Fq "$SOURCE_LINE" "$rc_file"; then
    local tmp_file
    tmp_file="$(mktemp)"
    awk -v line="$SOURCE_LINE" '$0 != line' "$rc_file" > "$tmp_file"
    mv "$tmp_file" "$rc_file"
    echo "Updated: $rc_file"
  fi
}

remove_source_line "$HOME/.bashrc"
remove_source_line "$HOME/.zshrc"

if [ -d "$DEST_DIR" ]; then
  rm -rf "$DEST_DIR"
  echo "Removed: $DEST_DIR"
fi

echo ""
echo "ld uninstalled."
echo "Open a new terminal or reload your shell."
