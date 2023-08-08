#!/usr/bin/env bash

get_device() {
  if [[ $(bluetoothctl devices Connected) != "" ]]; then
    bluetoothctl devices Connected | awk '{ for (i = 3; i <= NF; i++) { printf("%s ", $i) } printf("\n") }'
  else
    echo "Disconnected"
  fi
}

get_state() {
  if [[ "$(rfkill list | grep -A 1 hci0 | grep -o no)" == "no" ]]; then
    echo " 󰂯 "
  else
    echo " 󰂲 " 
  fi
}

[[ "$1" == "device" ]] && get_device
[[ "$1" == "toggle" ]] && rfkill toggle bluetooth

if [[ $1 == "icon" ]]; then
  while true; do
    sleep 0.1
    get_state
  done
fi
