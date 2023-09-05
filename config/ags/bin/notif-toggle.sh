#!/usr/bin/env bash

on () {
  swaync-client -op

  eww open closer-notif1
  eww open closer-notif2
  eww open closer-notif3
  eww open closer-notif4
  
  eww update notif-panel-state=true
}

off () {
  swaync-client -cp

  eww update notif-panel-state=false

  eww close closer-notif1
  eww close closer-notif2
  eww close closer-notif3
  eww close closer-notif4
}

toggle() {
  if [[ $(eww get notif-panel-state) == "true" ]]; then
    echo "Off"
    off > /dev/null
  else
    echo "On"
    on > /dev/null
  fi
}

state() {
  if [[ $(eww get notif-panel-state) == "true" ]]; then
    echo "Off"
  else
    echo "On"
  fi
}

[[ "$1" == "toggle" ]] && toggle
if [[ "$1" == "state" ]]; then
   while true; do 
    state
    sleep 1
  done
fi
