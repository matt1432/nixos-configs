#!/bin/bash
SIDE="$1"
workspaces=($(swaymsg -t get_workspaces | jq '.[] | .num'))
list_focused=($(swaymsg -t get_workspaces | jq '.[] | .focused'))

for (( i=0; i<${#workspaces[@]}; i++ ));
do
	if [[ ${list_focused[$i]} == true ]]; then
		current_workspace=${workspaces[$i]}
		break
	fi
done

if [[ ${workspaces[-1]} == ${workspaces[0]} ]]; then
	if [[ $current_workspace == "1" ]]; then
		swaymsg workspace 2

	elif [[ $SIDE == "prev" ]]; then
		swaymsg workspace $[${workspaces[0]} - 1]

	elif [[ $SIDE == "next" ]]; then
		swaymsg workspace $[${workspaces[0]} + 1]
	fi

elif [[ $SIDE == "prev" ]]; then
	if [[ $current_workspace == "1" ]]; then
		swaymsg workspace ${workspaces[-1]}
	else
		swaymsg workspace $[$current_workspace - 1]
	fi

elif [[ $SIDE == "next" ]]; then
	swaymsg workspace $[$current_workspace + 1]
fi
sudo input-emulator touch tap 1280 720
