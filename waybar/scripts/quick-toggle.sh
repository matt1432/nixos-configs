#!/bin/bash

if [[ $(eww state | grep br_icon) ]]; then
	eww close actions && eww close actions-closer
else
	eww open actions && eww open actions-closer
fi
