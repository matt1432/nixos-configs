#!/usr/bin/env bash

gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false

brightnessctl -d tpacpi::kbd_backlight s 2

killall -r autorotate.sh
killall -r evtest

eww close tablet
eww update tablet-ts=false
