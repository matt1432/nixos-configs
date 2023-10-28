#!/usr/bin/env bash

grim -t jpeg /tmp/image.jpeg
convert /tmp/image.jpeg -blur 0x8 /tmp/image.jpeg

