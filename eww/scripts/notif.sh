#!/usr/bin/env bash

state () {
  if [[ $(hyprctl layers | grep swaync-control-center) == "" ]]; then
    eww update notif-panel-state=false
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
  icon
fi

