#!/bin/bash
if [[ $(eww state) ]]; then
	eww close-all
fi
input-emulator kbd key esc
