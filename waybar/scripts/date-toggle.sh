#!/bin/bash

if [[ $(eww state | grep calendar_month) ]]; then
	eww close date && eww close closer
else
	eww close-all
	eww open date && eww open closer
fi
