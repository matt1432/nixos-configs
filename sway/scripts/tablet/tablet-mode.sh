#!/bin/bash
eww update toggle-state=true
setsysmode tablet

gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

brightnessctl -d tpacpi::kbd_backlight s 0

$HOME/.config/sway/scripts/tablet/autorotate.sh

