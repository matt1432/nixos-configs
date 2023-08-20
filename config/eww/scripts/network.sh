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
    eww update network_icon=" 󰖩 "
  else
    eww update network_icon=" 󰖪 " 
  fi
}

[[ "$1" == "ssid" ]] && get_ssid

if [[ "$1" == "toggle" ]]; then
  rfkill toggle wlan
  get_state
fi

if [[ $1 == "icon" ]]; then
  while true; do
    get_state
    sleep 1
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
