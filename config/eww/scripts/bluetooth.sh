#!/usr/bin/env bash

FILE="$HOME/.config/.bluetooth"

get_device() {
  if [[ $(bluetoothctl devices Connected) != "" ]]; then
    bluetoothctl devices Connected | awk '{ for (i = 3; i <= NF; i++) { printf("%s ", $i) } printf("\n") }'
  else
    echo "Disconnected"
  fi
}

get_state() {
  if [[ "$(rfkill list | grep -A 1 hci0 | grep -o no)" == "no" ]]; then
    eww update bluetooth_icon=" 󰂯 "
    echo " 󰂯 " > "$FILE"
  else
    eww update bluetooth_icon=" 󰂲 "
    echo " 󰂲 " > "$FILE"
  fi
}

[[ "$1" == "device" ]] && get_device
if [[ "$1" == "toggle" ]]; then
  rfkill toggle bluetooth
  get_state
fi

if [[ $1 == "icon" ]]; then
  while true; do
    sleep 1
    get_state
    tail "$FILE"
  done
fi
