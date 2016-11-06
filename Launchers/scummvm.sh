# fix mouse input
export SDL_MOUSE_RELATIVE=0

# enable long-touch as right-click
export SDL_MOUSEDEV="/dev/input/by-path/platform-1c25000.rtp-event"

# hack to change 5 button to F5 to allow saving
xmodmap -e "keycode  14 = F5 percent 5 percent"

# start in 320x240 resolution with subtitles
scummvm -f --gfx-mode="1x" --aspect-ratio -n

# reset 5 button when finished
xmodmap -e "keycode  14 = 5 percent F5 percent"
