#!/usr/bin/env bash

SOURCE="@DEFAULT_SOURCE@"

is_muted () {
  pactl get-source-mute $SOURCE | awk '{print $2}'
}

get_icon () {
  if [[ $(is_muted) == "yes" ]]; then
    echo " 󰍭"
  else
    echo " 󰍬"
  fi
}

if [[ $1 == "icon" ]]; then
  while true; do
    sleep 0.01
    get_icon
  done
fi

if [[ $1 == "muted" ]]; then
  is_muted
fi

if [[ $1 == "toggle-muted" ]]; then
  swayosd --input-volume mute-toggle
fi
