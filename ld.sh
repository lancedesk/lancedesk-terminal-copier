#!/usr/bin/env bash
# shellcheck shell=bash

# ld: lightweight terminal logger for bash/zsh
# Usage: ld start | ld stop | ld c | ld status | ld show | ld recover | ld help

_ld_err() {
  local code="$1"
  shift
  printf '%s\n' "$*"
  return "$code"
}

_ld_copy_to_clipboard() {
  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy
    return 0
  fi
  if command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
    return 0
  fi
  if command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --input
    return 0
  fi
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy
    return 0
  fi
  if command -v clip.exe >/dev/null 2>&1; then
    clip.exe
    return 0
  fi
  return 1
}

_ld_last_log_file() {
  local state_file="$HOME/.local/state/ld/current_log"
  if [ -f "$state_file" ]; then
    cat "$state_file"
  fi
}

_ld_version() {
  local version_file="$HOME/.config/ld/VERSION"
  if [ -f "$version_file" ]; then
    cat "$version_file"
  else
    printf '%s\n' "dev"
  fi
}

ld() {
  local cmd="${1:-help}"
  local logs_dir="$HOME/.local/share/ld/logs"
  local state_dir="$HOME/.local/state/ld"
  local state_file="$state_dir/current_log"

  case "$cmd" in
    start)
      if [ "${LD_ACTIVE:-0}" = "1" ]; then
        _ld_err 10 "[ld] Already recording: ${LD_LOG_FILE}"
        return 10
      fi

      mkdir -p "$logs_dir" "$state_dir"
      export LD_LOG_FILE="$logs_dir/ld-$(date +%Y%m%d-%H%M%S).log"
      : > "$LD_LOG_FILE"
      printf '%s\n' "$LD_LOG_FILE" > "$state_file"

      exec 9>&1 8>&2
      export LD_FDS_SAVED=1
      export LD_ACTIVE=1
      exec > >(tee -a "$LD_LOG_FILE") 2>&1

      echo "[ld] Recording started"
      echo "[ld] Log file: $LD_LOG_FILE"
      echo "[ld] Run: ld stop  (then ld c to copy)"
      ;;

    stop)
      if [ "${LD_ACTIVE:-0}" != "1" ]; then
        _ld_err 11 "[ld] Not currently recording"
        return 11
      fi

      if [ "${LD_FDS_SAVED:-0}" != "1" ]; then
        unset LD_ACTIVE LD_FDS_SAVED
        _ld_err 12 "[ld] Recorder state is inconsistent. Use: ld status ; ld start"
        return 12
      fi

      exec 1>&9 2>&8
      exec 9>&- 8>&-
      unset LD_ACTIVE LD_FDS_SAVED

      echo "[ld] Recording stopped"
      echo "[ld] Log file: ${LD_LOG_FILE}"
      ;;

    c|copy|+c)
      local file="${2:-${LD_LOG_FILE:-$(_ld_last_log_file)}}"
      if [ -z "$file" ] || [ ! -f "$file" ]; then
        _ld_err 20 "[ld] No log file found. Start a recording first with: ld start"
        return 20
      fi

      if _ld_copy_to_clipboard < "$file"; then
        echo "[ld] Copied to clipboard: $file"
      else
        _ld_err 21 "[ld] Could not find clipboard tool (wl-copy/xclip/xsel/pbcopy/clip.exe)"
        _ld_err 21 "[ld] Log file is still available at: $file"
        return 21
      fi
      ;;

    show)
      local file="${2:-${LD_LOG_FILE:-$(_ld_last_log_file)}}"
      if [ -z "$file" ] || [ ! -f "$file" ]; then
        _ld_err 22 "[ld] No log file found"
        return 22
      fi
      cat "$file"
      ;;

    status)
      if [ "${LD_ACTIVE:-0}" = "1" ]; then
        echo "[ld] Status: recording"
        echo "[ld] Log file: ${LD_LOG_FILE}"
      else
        echo "[ld] Status: idle"
        local file="$(_ld_last_log_file)"
        if [ -n "$file" ]; then
          echo "[ld] Last log: $file"
        fi
      fi
      ;;

    recover)
      if [ "${LD_ACTIVE:-0}" = "1" ] && [ "${LD_FDS_SAVED:-0}" = "1" ]; then
        exec 1>&9 2>&8
        exec 9>&- 8>&-
      fi
      unset LD_ACTIVE LD_FDS_SAVED
      echo "[ld] Recorder state reset to idle"
      ;;

    version|-v|--version)
      printf 'ld %s\n' "$(_ld_version)"
      ;;

    help|-h|--help)
      cat <<'EOF'
ld command help:
  ld start         Start recording terminal output in this shell
  ld stop          Stop recording in this shell
  ld c             Copy current/last log to clipboard
  ld +c            Same as ld c
  ld show          Print current/last log to terminal
  ld status        Show recorder status and file
  ld recover       Reset recorder state after interrupted sessions
  ld version       Show installed ld version
  ld help          Show this help

Tip:
  Start with 'ld start', run your commands, then 'ld stop' and 'ld c'.

Exit codes for automation:
  10  already recording
  11  stop requested while idle
  12  inconsistent recorder state
  20  no log available to copy
  21  no supported clipboard utility found
  22  no log available to show
EOF
      ;;

    *)
      _ld_err 2 "[ld] Unknown command: $cmd"
      _ld_err 2 "[ld] Try: ld help"
      return 2
      ;;
  esac
}
