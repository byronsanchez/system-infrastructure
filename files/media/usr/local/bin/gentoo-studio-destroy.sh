#!/bin/sh

# Ensure jack configuration is disabled so that alsa can manage the audio 
# hardware on it's own
rm /home/byronsanchez/.asoundrc

# Restart audio services to use alsa as the audio device handler
sudo /etc/init.d/alsasound restart
sudo /etc/init.d/mpd restart

# Reduce performance to conserve battery power in casual mode
sudo /usr/local/bin/cpu-performance-casual
