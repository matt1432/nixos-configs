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

radio_status () {
  radio_status=$(nmcli radio wifi)
  if [[ $radio_status == "enabled" ]]; then
    echo "on"
  else
    echo "off"
  fi
}

if [[ $1 == "radio-status" ]]; then
  radio_status
fi

if [[ $1 == "toggle-radio" ]]; then
  stat=$(radio_status)
  if [[ $stat == "on" ]]; then
    nmcli radio wifi off
  else
    nmcli radio wifi on
  fi
fi
