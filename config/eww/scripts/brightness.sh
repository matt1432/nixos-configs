#!/usr/bin/env bash

# @requires: brightnessctl

percentage () {
  local val=$(echo $1 | tr '%' ' ' | awk '{print $1}')
  local icon1=$2
  local icon2=$3
  local icon3=$4
  local icon4=$5
  local icon5=$6
  local icon6=$7
  local icon7=$8
  local icon8=$9
  if [ "$val" -le 1 ]; then
    echo "$icon1"
  elif [ "$val" -le 15 ]; then
    echo "$icon2"
  elif [ "$val" -le 30 ]; then
    echo "$icon3"
  elif [ "$val" -le 45 ]; then
    echo "$icon4"
  elif [ "$val" -le 60 ]; then
    echo "$icon5"
  elif [ "$val" -le 75 ]; then
    echo "$icon6"
  elif [ "$val" -le 90 ]; then
    echo "$icon7"
  else
    echo "$icon8"
  fi
}


get_brightness () {
  (( br = $(brightnessctl get) * 100 / $(brightnessctl max) ))
  echo $br
}

get_percent () {
  echo $(get_brightness)%
}

get_icon () {
  local br=$(get_percent)
  echo $(percentage "$br" " " " " " " " " " " "  " "  " "  ")
}

if [[ $1 == "br" ]]; then
  get_brightness
fi

if [[ $1 == "percent" ]]; then
  get_percent
fi

if [[ $1 == "icon" ]]; then
  while true; do
    sleep 0.2
    get_icon
  done
fi

if [[ $1 == "set" ]]; then
  brightnessctl set $2%
fi
