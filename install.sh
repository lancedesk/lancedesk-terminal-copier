#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_FILE="$SCRIPT_DIR/ld.sh"
DEST_DIR="$HOME/.config/ld"
DEST_FILE="$DEST_DIR/ld.sh"
SOURCE_LINE='[ -f "$HOME/.config/ld/ld.sh" ] && source "$HOME/.config/ld/ld.sh"'
UNINSTALL_HINT="$DEST_DIR/uninstall.sh"

mkdir -p "$DEST_DIR"
cp "$SRC_FILE" "$DEST_FILE"
cp "$SCRIPT_DIR/uninstall.sh" "$UNINSTALL_HINT"
chmod +x "$DEST_FILE" "$UNINSTALL_HINT"

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

detect_primary_shell_rc() {
  if [ -n "${ZSH_VERSION:-}" ] || [ "${SHELL##*/}" = "zsh" ]; then
    printf '%s' "~/.zshrc"
  else
    printf '%s' "~/.bashrc"
  fi
}

echo ""
echo "Installed: $DEST_FILE"
echo "Uninstall: $UNINSTALL_HINT"
echo "Open a new terminal or run: source $(detect_primary_shell_rc)"
echo "Usage: ld start ; <run commands> ; ld stop ; ld c"
