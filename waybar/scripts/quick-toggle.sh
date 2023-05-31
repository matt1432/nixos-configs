#!/bin/bash

if [[ $(eww state | grep br_icon) ]]; then
	$HOME/.config/eww/scripts/close.sh actions && eww close closer
else
	$HOME/.config/eww/scripts/close-opened.sh
	$HOME/.config/eww/scripts/open.sh actions && eww open closer
fi
