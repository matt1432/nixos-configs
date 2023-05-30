#!/bin/bash
if [[ $(eww state) ]]; then
	eww close-all
fi
