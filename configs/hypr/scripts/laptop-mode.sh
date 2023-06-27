#!/usr/bin/env bash
eww update toggle-state=false

gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false

brightnessctl -d tpacpi::kbd_backlight s 2

killall -r autorotate.sh
killall -r evtest
