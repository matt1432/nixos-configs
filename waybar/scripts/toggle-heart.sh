#!/bin/bash
TOGGLE=$HOME/.config/waybar/scripts/.heart

if [ ! -e $TOGGLE ]; then
    touch $TOGGLE
else
    rm $TOGGLE
fi
