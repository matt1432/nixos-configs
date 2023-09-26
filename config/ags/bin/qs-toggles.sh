#!/usr/bin/env bash

radio_status () {
  radio_status=$(nmcli radio wifi)
  if [[ $radio_status == "enabled" ]]; then
    echo "on"
  else
    echo "off"
  fi
}

if [[ $1 == "toggle-radio" ]]; then
  stat=$(radio_status)
  if [[ $stat == "on" ]]; then
    nmcli radio wifi off
  else
    nmcli radio wifi on
  fi
fi

FILE='/home/matt/.config/.bluetooth'
get_state() {
  if [[ "$(rfkill list | grep -A 1 hci0 | grep -o no)" == "no" ]]; then
    echo " 󰂯 " > "$FILE"
  else
    echo " 󰂲 " > "$FILE"
  fi
}

if [[ "$1" == "blue-toggle" ]]; then
  rfkill toggle bluetooth
  get_state
fi
