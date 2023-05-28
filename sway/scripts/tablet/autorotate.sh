#!/bin/bash

# This script handles rotation of the screen and related input devices automatically
# using the output of the monitor-sensor command (part of the iio-sensor-proxy package)
# for sway.
# The target screen and input device names should be configured in the below variables.
# Note: input devices using the libinput driver (e.g. touchscreens) should be included
# in the WAYLANDINPUT array.
#
# You can get a list of input devices with the `swaymsg -t output` command.
#
# This script was forked from https://gitlab.com/snippets/1793649 by Fishonadish


SCREEN="eDP-1"
WAYLANDINPUT=("1386:21227:Wacom_HID_52EB_Finger"
	      "1386:21227:Wacom_HID_52EB_Pen")


function rotate_ms {
    case $1 in
        "normal")
            rotate 0
            /home/matt/.config/lisgd/config &
            ;;
        "right-up")
            rotate 90
            /home/matt/.config/lisgd/config &
            ;;
        "bottom-up")
            rotate 180
            /home/matt/.config/lisgd/config &
            ;;
        "left-up")
            rotate 270
            /home/matt/.config/lisgd/config &
            ;;
    esac
}

function rotate {
    swww img $HOME/Pictures/BG/black.jpg
    sleep 0.1

    TARGET_ORIENTATION=$1

    echo "Rotating to" $TARGET_ORIENTATION

    swaymsg output $SCREEN transform $TARGET_ORIENTATION
    swww img $HOME/Pictures/BG/bonzai.jpg

    for i in "${WAYLANDINPUT[@]}" 
    do
        swaymsg input "$i" map_to_output "$SCREEN"
    done

}

while IFS='$\n' read -r line; do
    rotation="$(echo $line | sed -En "s/^.*orientation changed: (.*)/\1/p")"
    [[ !  -z  $rotation  ]] && rotate_ms $rotation
done < <(stdbuf -oL monitor-sensor)

