node 'mira.internal.nitelite.io' inherits network {

  # USE flags set according to Gentoo Studio for DAW in addition to custom
  # configs
  $gentoo_studio_use_flags = "a52 aac aacplus alsa audacious cdda cddb cdio consolekit corefonts dbus dirac dssi dts dv dvd encode equalizer faac ffmpeg fftw flac fluidsynth freesound g3dvl gif gtk gudev hwdb id3 id3tag ieee1394 jack jackmidi jpeg ladspa lame libsamplerate lv2 mad matroska midi mp3 mp4 mpeg musepack musicbrainz netjack ogg opengl png policykit python quicktime realtime rubberband schroedinger shine shout sndfile soundtouch svg taglib theora tiff timidity truetype twolame udev usb vamp vcd vorbis wav wavpack X x264 xine xvfb xvid xvmc -pulseaudio -xscreensaver"
  # USE flags from /proc/cpuinfo
  # NOTE: Change this whenever your workstation changes; these are USE flags
  # specific to the CPU
  $workstation_use_flags = "fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida dtherm tpr_shadow vnmi flexpriority"

  class { "base":
    hostname          => "mira",
    network_interface => "wlan0",
  }

  class { "gentoo":
    use_flags     => "${gentoo_studio_use_flags} ${workstation_use_flags} mysql bluetooth",
    linguas       => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    video_cards   => "nouveau",
    input_devices => "evdev synaptics",
    lowmemorybox  => false,
  }

  class { "security":
    iptables_type => "workstation",
  }

  class { "ssh":
    username => [
      "root",
      "rbackup",
      "staff",
      "byronsanchez",
    ],
  }

  class { "backup":
    backup_type => "workstation",
  }

  class { "vcs": }

  class { "nasclient": }

  class { "pki":
    ca_type => "mira",
  }

  class { "vpn":
    vpn_type => "client",
  }

  class { "xorgserver":
    xorg_driver => "nouveau",
    xorg_busid  => "PCI:1:0:0",
  }

  class { "media": }

  class { "workstation": }

  class { "nodejs": }

  class { "php": }

  class { "java": }

  class { "ruby": }

  class { "nl_rvm":
    user => "byronsanchez",
    home => "/home/byronsanchez",
  }

  class { "nl_nvm":
    user => "byronsanchez",
    home => "/home/byronsanchez",
  }

  class { "mobile": }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }
  class { "byronsanchez":
    #groups => ['plugdev', 'android'],
    groups  => ['audio', 'realtime', 'cdrom', 'usb', 'wheel',],
  }
  class { "logger": }

}
