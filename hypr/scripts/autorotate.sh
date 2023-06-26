#!/usr/bin/env bash

# This script was forked from https://gitlab.com/snippets/1793649 by Fishonadish


SCREEN="eDP-1"
WAYLANDINPUT=("wacom-hid-52eb-finger"
	      "wacom-hid-52eb-pen")



function rotate_ms {
    if [[ $(hyprctl activewindow | grep Waydroid) == "" ]]; then
        case $1 in
            "normal")
                rotate 0
                ;;
            "right-up")
                rotate 3
                ;;
            "bottom-up")
                rotate 2
                ;;
            "left-up")
                rotate 1
                ;;
        esac
    elif [[ $(hyprctl monitors | grep "transform: 0") == "" ]]; then 
        rotate 0
    fi
}

function rotate {
      TARGET_ORIENTATION=$1

      echo "Rotating to" $TARGET_ORIENTATION

      hyprctl keyword monitor $SCREEN,transform,$TARGET_ORIENTATION

      for i in "${WAYLANDINPUT[@]}" 
      do
          hyprctl keyword device:"$i":transform $TARGET_ORIENTATION
      done

      /home/matt/.config/lisgd/config &
}

while IFS='$\n' read -r line; do
    rotation="$(echo $line | sed -En "s/^.*orientation changed: (.*)/\1/p")"
    [[ !  -z  $rotation  ]] && rotate_ms $rotation
done < <(stdbuf -oL monitor-sensor)
