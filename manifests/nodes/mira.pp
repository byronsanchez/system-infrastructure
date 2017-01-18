node 'mira.internal.nitelite.io' inherits network {

  # USE flags set according to Gentoo Studio for DAW in addition to custom
  # configs
  $gentoo_studio_use_flags = "a52 aac aacplus alsa audacious cdda cddb cdio consolekit corefonts dbus dirac dssi dts dv dvd encode equalizer faac ffmpeg fftw flac fluidsynth freesound g3dvl gif gtk gudev hwdb id3 id3tag ieee1394 jack jackmidi jpeg ladspa lame libsamplerate lv2 mad matroska midi mp3 mp4 mpeg mpg123 musepack musicbrainz netjack ogg opengl png policykit python quicktime realtime rubberband schroedinger shine shout sndfile soundtouch svg taglib theora tiff timidity truetype twolame udev usb vamp vcd vorbis wav wavpack X x264 xine xvfb xvid xvmc -pulseaudio -xscreensaver"
  # USE flags from /proc/cpuinfo AND cpuinfo2cpuflags-x86
  # NOTE: Change this whenever your workstation changes; these are USE flags
  # specific to the CPU
  $workstation_cpu_flags = "fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida dtherm tpr_shadow vnmi flexpriority mmx mmxext sse sse2 sse3 sse4_1 ssse3"

  class { "base":
    hostname          => "mira",
    network_interface => "wlan0",
    keymap            => "us",
    enable_docker     => false,
    enable_chroot     => true,
    enable_dropbox    => true,
  }

  class { "gentoo":
    use_flags     => "${gentoo_studio_use_flags} postgres pulseaudio bluetooth qt3support xinerama ffmpeg -libav",
    cpu_flags     => "${workstation_cpu_flags}",
    linguas       => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    video_cards   => "intel i915",
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

  class { "nas":
    nas_type   => "workstation",
  }

  class { "pki":
    ca_type => "mira",
  }

  # class { "vpn":
  #   vpn_type => "client",
  # }

  class { "xorgserver":
    xorg_driver   => "intel",
    xorg_busid    => "PCI:1:0:0",
    xorg_keyboard => "colemak",
    xorg_type     => "workstation",
  }

  class { "mirror": }

  class { "media": }

  class { "laptop": }

  class { "workstation":
    xorg_apps   => true,
    skype       => false,
  }

  class { "nodejs": }

  class { "java": }

  class { "ruby": }

  # node management
  class { "rsyncd": }
  # class { "provision": }

  class { "nl_nvm":
    user => "byronsanchez",
    home => "/home/byronsanchez",
  }

  nl_rvm::user_install { "byronsanchez_rvm":
    user    => "byronsanchez",
    home    => "/home/byronsanchez",
  }

  class { "mobile": }

  class { "mail":
    mail_type => "server",
  }

  # users
  class { "byronsanchez":
    #groups => ['plugdev', 'android'],
    groups  => ['audio', 'realtime', 'cdrom', 'cron', 'crontab', 'joy', 'lp', 'lpadmin', 'usb', 'vboxusers', 'video', 'wheel',],
  }

}
