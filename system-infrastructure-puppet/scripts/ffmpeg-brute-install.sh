#!/bin/sh
#
# Run this script while installing ffmpeg (dep for media pattern's mpd) and then 
# kill it once the install is complete.
# See: http://forums.gentoo.org/viewtopic-p-7432456.html#7432456

FOO=1
while [ $FOO -eq 1 ];
do
  chmod 755 /var/tmp/portage/media-video/ffmpeg-*/temp/;
  sleep 0.1;
done 
