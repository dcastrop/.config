#!/bin/sh

current_vol=$(pactl -- get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{print $2}' |  tr -d \\n | sed 's/[^0-9]*//g')

[ $current_vol -lt 100 ] && pactl set-sink-volume @DEFAULT_SINK@ +1%
