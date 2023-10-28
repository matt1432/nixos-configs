#!/usr/bin/env bash

## Make bluetooth status persistent between reboots
if [[ ! -f "$HOME/.config/.bluetooth" ]]; then
  echo 󰂲 > "$FILE"
fi

if grep -q 󰂲 "$HOME/.config/.bluetooth"; then
  rfkill block bluetooth
fi
