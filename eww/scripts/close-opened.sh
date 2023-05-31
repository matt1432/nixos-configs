#!/bin/bash

# Store the output of the command in an array, keeping only lines with '*'
readarray -t array <<< "$(eww windows | grep '^\*')"

# Remove the '*' from each element
for ((i=0; i<${#array[@]}; i++))
do
	array[i]=${array[i]#'*'}
	array[i]=${array[i]%-reveal}
done

# Print the elements of the array
for element in "${array[@]}"
do
	$HOME/.config/eww/scripts/close.sh "$element"
done
