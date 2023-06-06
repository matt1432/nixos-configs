#!/bin/bash

if [[ $(eww state | grep calendar_month) ]]; then
	$HOME/.config/eww/scripts/close.sh date && eww close closer
else
	$HOME/.config/eww/scripts/close-opened.sh
	eww open closer && $HOME/.config/eww/scripts/open.sh date
fi
