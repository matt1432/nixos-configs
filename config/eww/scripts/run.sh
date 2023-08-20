#!/usr/bin/env bash

FILE="$HOME/.config/.on-release"
SCRIPT="$1"
VAR="$2"

function run() {
  if [[ $(eww get "$VAR") == "true" ]]; then
    if [[ $(eww get cancel_touch) == "false" ]]; then
      bash -c "$SCRIPT"
    fi
  else
    eww open on-release-fix
    sleep 0.1
    input-emulator mouse button left
  fi
  exit 0
}

while IFS='$\n' read -r line; do
  [[ $(grep "can_run" "$FILE") != "" ]] && run
done < <(stdbuf -oL tail -f "$FILE")
