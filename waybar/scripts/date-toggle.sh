#!/bin/bash

if [[ $(eww state | grep calendar_month) ]]; then
	$HOME/.config/eww/scripts/close.sh date && eww close closer
else
	$HOME/.config/eww/scripts/close-opened.sh
	$HOME/.config/eww/scripts/open.sh date && eww open closer
fi
