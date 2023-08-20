#!/usr/bin/env bash

get_icon () {
  val=$(brightnessctl get)

  if [ "$val" -le 3 ]; then
    eww update br_icon=" "

  elif [ "$val" -le 38 ]; then
    eww update br_icon=" "

  elif [ "$val" -le 77 ]; then
    eww update br_icon=" "

  elif [ "$val" -le 115 ]; then
    eww update br_icon=" "

  elif [ "$val" -le 153 ]; then
    eww update br_icon=" "

  elif [ "$val" -le 191 ]; then
    eww update br_icon="  "

  elif [ "$val" -le 230 ]; then
    eww update br_icon="  "

  else
    eww update br_icon="  "
  fi
}

if [[ $1 == "br" ]]; then
  brightnessctl get
fi

if [[ $1 == "icon" ]]; then
  while true; do
    get_icon
    sleep 1
  done
fi

if [[ $1 == "set" ]]; then
  brightnessctl set "$2"
  get_icon
fi
