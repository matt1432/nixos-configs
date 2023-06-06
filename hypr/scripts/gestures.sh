#!/bin/bash
SIDE="$1"
TOUCH="$2"
workspaces=($(hyprctl workspaces -j | jq '.[] | .id'))
current_workspace=$(hyprctl monitors -j | jq '.[0].activeWorkspace.id')

echo $current_workspace
if [[ ${workspaces[-1]} == ${workspaces[0]} ]]; then
	if [[ $current_workspace == "1" ]]; then
		hyprctl dispatch workspace 2

	elif [[ $SIDE == "prev" ]]; then
		hyprctl dispatch workspace $[${workspaces[0]} - 1]

	elif [[ $SIDE == "next" ]]; then
		hyprctl dispatch workspace $[${workspaces[0]} + 1]
	fi

elif [[ $SIDE == "prev" ]]; then
	if [[ $current_workspace == "1" ]]; then
		hyprctl dispatch workspace ${workspaces[-1]}
	else
		hyprctl dispatch workspace $[$current_workspace - 1]
	fi

elif [[ $SIDE == "next" ]]; then
	hyprctl dispatch workspace $[$current_workspace + 1]
fi

if [[ $TOUCH == "touch" ]]; then
	sleep 0.2
	sudo input-emulator touch tap 1280 720
fi
