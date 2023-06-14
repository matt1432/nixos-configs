#!/usr/bin/env bash

grim /tmp/image.png
convert /tmp/image.png -channel RGBA -blur 0x8 /tmp/image.png

