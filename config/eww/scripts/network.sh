#!/usr/bin/env bash

get_ssid() {
  if nmcli -t -f NAME c show --active | grep -v lo; then
    true
  else
    echo "Disconnected"
  fi
}

[[ "$1" == "ssid" ]] && get_ssid
