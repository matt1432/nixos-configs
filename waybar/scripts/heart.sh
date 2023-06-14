#!/usr/bin/env bash
TOGGLE=$HOME/.config/waybar/scripts/.heart

if [ ! -e $TOGGLE ]; then
	echo " 󰣐 "
else
	echo "  "
fi
