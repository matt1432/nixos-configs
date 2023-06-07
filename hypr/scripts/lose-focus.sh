#!/bin/bash

while true
do
	while killall -0 blueman-manager > /dev/null 2>&1
	do
		if [[ $(bluetoothctl show | grep Powered | grep yes) ]]; then
			if [[ $(hyprctl activewindow | grep blueman-manager) == "" && $(hyprctl clients | grep blueman-manager) != "" ]]; then
	                	killall blueman-manager
        	        	break
        		fi
        		sleep 0.1
        	fi
	done
	sleep 0.1
done
