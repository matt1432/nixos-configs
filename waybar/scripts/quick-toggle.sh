#!/bin/bash

if [[ $(eww state | grep br_icon) ]]; then
	eww close actions && eww close closer
else
	eww close-all
	eww open actions && eww open closer
fi
