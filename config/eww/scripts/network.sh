#!/usr/bin/env bash

get_ssid() {
  if nmcli -t -f NAME c show --active | grep -v lo; then
    true
  else
    echo "Disconnected"
  fi
}

get_state() {
  if [[ "$(rfkill list | grep -A 1 LAN | grep -o no)" == "no" ]]; then
    echo " 󰖩 "
  else
    echo " 󰖪 " 
  fi
}

[[ "$1" == "ssid" ]] && get_ssid
[[ "$1" == "toggle" ]] && rfkill toggle wlan

if [[ $1 == "icon" ]]; then
  while true; do
    sleep 0.1
    get_state
  done
fi
