#!/usr/bin/env bash

tablet() {
  gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

  brightnessctl -d tpacpi::kbd_backlight s 0

  "$HYPR_PATH"/autorotate.sh &

  evtest --grab "/dev/input/by-path/platform-i8042-serio-0-event-kbd" &
  evtest --grab "/dev/input/by-path/platform-i8042-serio-1-event-mouse" &
  evtest --grab "/dev/input/by-path/platform-AMDI0010:02-event-mouse" &
  evtest --grab "/dev/input/by-path/platform-thinkpad_acpi-event" &
  evtest --grab "/dev/video-bus" &
}

laptop() {
  gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false

  brightnessctl -d tpacpi::kbd_backlight s 2

  killall -r autorotate.sh
  killall -r evtest
}

toggle () {
  if [[ "$(gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)" == "false" ]]; then
    echo "Tablet"
    tablet > /dev/null
  else
    echo "Laptop"
    laptop > /dev/null
  fi
}

[[ $1 == "toggle" ]] && toggle
[[ $1 == "laptop" ]] && laptop
[[ $1 == "tablet" ]] && tablet
