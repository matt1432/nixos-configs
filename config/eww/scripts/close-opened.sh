#!/usr/bin/env bash

# Store the output of the command in an array, keeping only lines with '*'
readarray -t array <<< "$(eww windows | grep '^\*')"

# Remove the '*' from each element
for ((i=0; i<${#array[@]}; i++))
do
	array[i]=${array[i]#'*'}
done

# Close every window except permanent ones
for element in "${array[@]}"
do
	[[ "$element" != "left-bar" ]] &&
  [[ "$element" != "notif-panel" ]] &&
  [[ "$element" != "notif-panel-on" ]] &&
  [[ "$element" != "heart" ]] &&
  [[ "$element" != "osk" ]] &&
  [[ "$element" != "tablet" ]] &&
  [[ "$element" != "quick-settings-toggle" ]] &&
  #[[ "$element" != "" ]] &&
	eww close "$element"
done
