#!/usr/bin/env bash

if [[ $(gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled) == true ]]; then
	$HOME/.config/sway/scripts/tablet/laptop-mode.sh
else
	$HOME/.config/sway/scripts/tablet/tablet-mode.sh
fi
