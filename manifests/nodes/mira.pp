node 'mira.fios-router.home' inherits network {

  # USE flags set according to Gentoo Studio for DAW in addition to custom
  # configs
  $gentoo_studio_use_flags = "a52 aac aacplus alsa audacious bindist cdda cddb cdio consolekit corefonts dbus dirac dssi dts dv dvd encode equalizer faac ffmpeg fftw flac fluidsynth freesound g3dvl gif gtk gudev hwdb icu id3 id3tag ieee1394 jack jackmidi jpeg ladspa lame libsamplerate lv2 mad matroska midi minizip mp3 mp4 mpeg mpg123 musepack musicbrainz netjack ogg opengl pcre16 png policykit python qt3support qt4 qt5 quicktime realtime rubberband schroedinger shine shout skins sndfile soundtouch svg taglib theora tiff timidity truetype twolame udev usb vamp vcd vorbis wav wavpack X x264 xine xkb xml xvfb xvid xvmc -introspection -pulseaudio -xscreensaver"

  # USE flags from /proc/cpuinfo AND cpuinfo2cpuflags-x86
  # NOTE: Change this whenever your workstation changes; these are USE flags
  # specific to the CPU
  $workstation_cpu_flags_t420 = "fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida dtherm tpr_shadow vnmi flexpriority mmx mmxext sse sse2 sse3 sse4_1 ssse3"

  $proc_cpu_info_flags_x220 = " fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm epb tpr_shadow vnmi flexpriority ept vpid pciduderef stronguderef xsaveopt dtherm ida arat pln pts"

  $workstation_cpu_flags_x220 = "aes avx mmx mmxext popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"

  $workstation_cpu_flags = "${proc_cpu_info_flags_x220} ${workstation_cpu_flags_x220}"

  class { "base":
    hostname               => "mira",
    network_interface      => "wlan0",
    network_type           => "workstation",
    keymap                 => "us",
    enable_docker          => false,
    enable_chroot          => true,
    enable_dropbox         => true,
    enable_workstation_kvm => true,
  }

  class { "gentoo":
    use_flags      => "${gentoo_studio_use_flags} postgres pulseaudio bluetooth qt3support xinerama ffmpeg -libav",
    cpu_flags      => "${workstation_cpu_flags}",
    linguas        => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    video_cards    => "radeon",
    input_devices  => "evdev synaptics wacom",
    accept_license => "*",
    lowmemorybox   => false,
    build_kernel   => true,
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
    xorg_driver   => "radeon",
    #xorg_busid    => "PCI:1:0:0",
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
  class { "provision": }

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
    # plugdev for bluetooth
    #
    # we don't add audio, because the audio group has to be clear for consolekit 
    # managed permissions to be respected (this is needed for pulseaudio)
    #
    # update: we're adding to the audio group now for JACK support
    #
    # from arch wiki: Note: You need to manually add your user to the audio
    # group even if you're using logind, since logind just handles access to
    # direct hardware.
    groups  => ['realtime', 'cdrom', 'cron', 'crontab', 'joy', 'lp', 'lpadmin', 'usb', 'video', 'wheel', 'plugdev', 'users', 'audio'],
  }

}
