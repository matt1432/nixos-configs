#!/usr/bin/env bash

echo "$XDG_DATA_DIRS" >> ~/log.log
gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

brightnessctl -d tpacpi::kbd_backlight s 0

"$HYPR_PATH"/autorotate.sh &

evtest --grab "/dev/input/by-path/platform-i8042-serio-0-event-kbd" &
evtest --grab "/dev/input/by-path/platform-i8042-serio-1-event-mouse" &
evtest --grab "/dev/input/by-path/platform-AMDI0010:02-event-mouse" &
evtest --grab "/dev/input/by-path/platform-thinkpad_acpi-event" &
evtest --grab "/dev/video-bus" &

eww update tablet-ts=true
