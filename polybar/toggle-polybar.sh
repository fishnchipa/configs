#!/bin/bash
if pgrep -x "polybar" > /dev/null; then
    killall -q polybar
else
    polybar top &
fi
