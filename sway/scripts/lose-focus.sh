#!/bin/bash

while true
do
	while killall -0 blueman-manager
	do
		if [[ $(bluetoothctl show | grep Powered | grep yes) ]]; then
			if [[ $(swaymsg -t get_tree | grep -B 39 blueman | grep "focused.: false") != "" ]]; then
	                	killall blueman-manager
        	        	break
        		fi
        		sleep 0.1
        	fi
	done
	sleep 0.1
done
