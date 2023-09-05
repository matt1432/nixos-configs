#!/usr/bin/env bash

on () {
  eww open closer &&

  eww open quick-settings-reveal;
  eww update showqs=true;
}

off () {
  eww update showqs=false;
  eww close quick-settings-reveal;
}

toggle() {
  if [[ $(eww get showqs) == "true" ]]; then
    echo "Off"
    off > /dev/null
  else
    echo "On"
    on > /dev/null
  fi
}

state() {
  if [[ $(eww get showqs) == "true" ]]; then
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
