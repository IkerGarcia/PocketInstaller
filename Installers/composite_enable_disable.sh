#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/chip/.Xauthority
C=`xrandr | grep 480x272 | grep "*"`
if [ "$C" = "" ]; then :
	echo "composite active, switch back"
	xrandr --output Composite-1 --off
	xrandr --output None-1 --mode  480x272
else :
	echo "display active, switching to composite"
	xrandr --output None-1 --off
	xrandr --output Composite-1 --mode  NTSC
fi
