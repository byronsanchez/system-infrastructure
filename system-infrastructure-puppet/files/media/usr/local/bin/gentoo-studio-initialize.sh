#!/bin/sh

# Make sure alsa is configured for jack loopback for alsa native apps
ln -s /home/byronsanchez/.dotfiles/alsa/.asoundrc.jack /home/byronsanchez/.asoundrc

# Restart alsa and mpd to make sure they can play from the newly started jack 
# audio service
sudo /etc/init.d/alsasound restart
sudo /etc/init.d/mpd restart

# Set the performance cpu scaling governors. This is best for Ardour,
# consumes a lot of power!
sudo /usr/local/bin/cpu-performance-workstation

# output native alsa app audio to jack
/usr/local/bin/loop2jack;
# make old alsa midi sequencer available in jack midi
/usr/bin/a2jmidid -e &
