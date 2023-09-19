#!/usr/bin/env bash

APP="$1"
EXEC="$2"

if [[ "$APP" == "thunderbird" ]]; then 
  hyprctl dispatch togglespecialworkspace thunder
elif [[ "$APP" == "Spotify" ]]; then
  hyprctl dispatch togglespecialworkspace spot
elif [[ $(hyprctl clients | grep "$APP") != "" ]]; then
  hyprctl dispatch focuswindow "^($APP)$"
else
  hyprctl dispatch workspace empty
  hyprctl dispatch exec "$EXEC"
fi
