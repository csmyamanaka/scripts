#!/bin/sh

#lock image selector
#"lockimg.sh"
#M. Yamanaka
#email: myamanaka@live.com
#website: csmyamanaka.com
#license: MIT (See included "LICENSE" file for details)

##
## Description
##
## This is a wrapper script for i3lock that selects an image to be used as the background

## This assumes you have archlinux with the package "archlinux-wallpaper" installed
## If not, the variable WPDIR (wallpaper directory)can just be changed to something else

WPDIR=/usr/share/backgrounds/archlinux

## i3lock, to my knowledge, does not automatically resize the image to fit with your screen
## so it's necessary to do some work on these images if you want a nice lock screen that
## isn't cropped weirdly or anything like that.

## imagemagick's resize accepts screen resolutions in the format 1200x800

SCRSIZE=$(xrandr | grep "current" | awk '{print $8"x"$10}' | sed s/,//g)

## Because the files in WPDIR are owned by root, you won't be able to overwrite them so
## you need to set a destination file. This assumes you have .local/tmp but this can be
## wherever you want

LOCKIMG=$HOME/.local/tmp/lockimg.png

## I like to choose randomly from the .png images in the arch wallpaper directories
## for lock screen images. I tend to use the .jpg files for desktop wallpapers

ORIGIMG=$(ls $WPDIR/*.png | shuf -n 1)

## You can use imagemagick to make a resized copy of the wallpaper to $LOCKIMG

convert $ORIGIMG -resize $SCRSIZE\! $LOCKIMG

## now use i3lock or whatever screen locking program you choose

i3lock -i $LOCKIMG
