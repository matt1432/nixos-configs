#!/usr/bin/env bash

# Store the output of the command in an array, keeping only lines with '*'
readarray -t array <<< "$(eww windows | grep '^\*')"

# Remove the '*' from each element
for ((i=0; i<${#array[@]}; i++))
do
	array[i]=${array[i]#'*'}
	array[i]=${array[i]%-reveal}
done

# Close every window except permanent ones
for element in "${array[@]}"
do
	if [[ "$element" != "tablet-toggle" ]]; then
		"$EWW_PATH"/close.sh "$element"
	fi
done
