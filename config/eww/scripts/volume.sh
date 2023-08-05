#!/usr/bin/env bash

# @requires: pactl

#SINK=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1)
SINK="@DEFAULT_SINK@"

percentage () {
  local val=$(echo $1 | tr '%' ' ' | awk '{print $1}')
  local icon1=$2
  local icon2=$3
  local icon3=$4
  local icon4=$5
  if [ "$val" -le 15 ]; then
    echo $icon1
  elif [ "$val" -le 30 ]; then
    echo $icon2
  elif [ "$val" -le 60 ]; then
    echo $icon3
  else
    echo $icon4
  fi
}

is_muted () {
  pactl get-sink-mute $SINK | awk '{print $2}'
}

get_percentage () {
  if [[ $(is_muted) == 'yes' ]]; then
    echo 0%
  else
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk '{print $5}' | tr % " ")
    echo "${vol}%"
  fi
}

get_icon () {
  local vol=$(get_percentage)
  if [[ $vol == "0%" ]]; then
    echo " 婢"
  else
    echo $(percentage "$vol" "" "" "墳" "")
  fi
}

get_class () {
  local vol=$(get_percentage)
  if [[ $vol == "0%" ]]; then
    echo "red"
  else
    echo $(percentage "$vol" "red" "magenta" "yellow" "blue")
  fi
}

get_vol () {
  #local percent=$(get_percentage)
  #echo $percent | tr -d '%'
  echo $(pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk '{print $5}' | tr % " ")
}

if [[ $1 == "icon" ]]; then
  while true; do
    sleep 0.01
    get_icon
  done
fi

if [[ $1 == "class" ]]; then
  get_class
fi

if [[ $1 == "percentage" ]]; then
  get_percentage
fi

if [[ $1 == "vol" ]]; then
  get_vol
fi

if [[ $1 == "muted" ]]; then
  is_muted
fi

if [[ $1 == "toggle-muted" ]]; then
  pactl set-sink-mute $SINK toggle
fi

if [[ $1 == "set" ]]; then
  val=$(echo $2 | tr '.' ' ' | awk '{print $1}')
  if test $val -gt 100; then
    val=100
  fi
  pactl set-sink-volume $SINK $val%
fi
