#!/usr/bin/env bash

state () {
  if [[ $(hyprctl layers | grep swaync-control-center) == "" ]]; then
    if [[ $(eww get notif-panel-state) == "true" ]]; then
      eww update notif-panel-state=false
      eww reload
    fi
  fi
}

icon () {
  local COUNT=$(swaync-client -c)

  if [[ $(swaync-client -D) == "true" ]]; then
    echo " 󱏨"
  elif [[ $COUNT == "0" ]]; then
    echo "$COUNT  󰂜"
  else
    echo "$COUNT  󰂚"
  fi
  state
}

if [[ $1 == "icon" ]]; then
  while true; do
    sleep 0.2
    icon
  done
fi

