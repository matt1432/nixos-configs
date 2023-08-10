#!/usr/bin/env bash

FILE="$HOME/.config/.heart"

toggle() {
  if grep -q 󰣐 "$FILE"; then
    eww close heart
    eww update heart-ts=false
    echo  > "$FILE"
  else
    eww open heart
    eww update heart-ts=true
    echo 󰣐 >> "$FILE"
  fi
}

[[ "$1" == "toggle" ]] && toggle


startup() {
  if [[ ! -f "$FILE" ]]; then
    echo 󰣐 > "$FILE"
  fi

  if [[ ! -f "$HOME/.config/.bluetooth" ]]; then
    echo 󰂲 > "$FILE"
  fi

  if grep -q 󰂲 "$HOME/.config/.bluetooth"; then
    rfkill block bluetooth
  fi

  "$HYPR_PATH"/osk-toggle.sh getState &

  if grep -q 󰣐 "$FILE"; then
    eww close heart
    sleep 0.9 && 
    eww open heart
    eww update heart-ts=true
  fi

  tail -f "$FILE"
}

[[ "$1" == "startup" ]] && startup
