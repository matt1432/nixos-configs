#!/usr/bin/env bash

FILE="$HOME/.config/.heart"

toggle() {
  if grep -q 󰣐 "$FILE"; then
    echo  > "$FILE"
  else
    echo 󰣐 >> "$FILE"
  fi
}

[[ "$1" == "toggle" ]] && toggle
