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
  echo "cant_run" > "$FILE"
}

while IFS='$\n' read -r line; do
  [[ $(grep "can_run" "$FILE") != "" ]] && run
  [[ $(grep "cant_run" "$FILE") != "" ]] && exit 0
done < <(stdbuf -oL tail -f "$FILE")
