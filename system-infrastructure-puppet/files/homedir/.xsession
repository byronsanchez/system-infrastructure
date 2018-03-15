#!/bin/sh
#
# ~/.xsession

# for server tower
xrandr --newmode "1600x900_75.00"  151.25  1600 1704 1872 2144  900 903 908 942 -hsync +vsync
xrandr --addmode DVI-0 1600x900_75.00
xrandr --output DVI-0 --mode 1600x900_75.00

# Fast keyboard repeat rate
xset r rate 540 80

function wm() {

  # Load X resources
  [[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

  # set WM name
  xsetroot -name $1

  [[ -f ~/.compton.conf ]] && compton -b --config ~/.compton.conf

  exec $1

}

function run() {
  # start specified app
  exec $@
}

test -z $1 && wm ratpoison

case $1 in
  *) wm $1;
esac
