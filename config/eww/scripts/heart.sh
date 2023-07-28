#!/usr/bin/env bash

FILE="$HOME/.config/.heart"
if [[ ! -f "$FILE" ]]; then
  echo 󰣐 > "$FILE"
fi

if grep -q 󰣐 "$FILE"; then
  eww close heart
  eww update heart-ts=false
  echo  > "$FILE"
else
  eww open heart
  eww update heart-ts=true
  echo 󰣐 >> "$FILE"
fi
