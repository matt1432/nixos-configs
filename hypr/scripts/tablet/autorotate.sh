#!/bin/bash

execute() {
    echo "Rotating"
    /home/matt/.config/lisgd/config &
    lisgd_pid=$!  # Save the PID of the lisgd process
}

cleanup() {
    echo "Cleaning up..."
    kill $lisgd_pid  # Terminate the lisgd process
    wait $lisgd_pid  # Wait for the process to exit
}

# Register the cleanup function to be called on script exit
trap cleanup EXIT

# Loop to listen to the command
while IFS='$\n' read -r line; do
    rotation="$(echo $line | sed -En "s/^.*orientation changed: (.*)/\1/p")"
    [[ !  -z  $rotation  ]] && execute
done < <(stdbuf -oL monitor-sensor)
