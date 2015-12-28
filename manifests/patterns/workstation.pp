
# TODO: Skype should be in chroot only

class workstation {

  user { 'joy':
    ensure => 'present',
    gid    => '1016',
    shell  => '/bin/false',
    uid    => '1016',
  }

  group { 'joy':
    ensure => 'present',
    gid    => '1016',
  }

  # TODO: refine this file array style of resource declaration and apply it to
  # all classes where possible to reduce redundancy (eg. all conf.d type
  # files)
  #
  # TODO: start tracking all files for all managed apps

  $hibernate_files = [
    "/etc/hibernate/blacklisted-modules",
    "/etc/hibernate/common.conf",
    "/etc/hibernate/disk.conf",
    "/etc/hibernate/hibernate.conf",
    "/etc/hibernate/ram.conf",
    "/etc/hibernate/sysfs-disk.conf",
    "/etc/hibernate/sysfs-ram.conf",
    "/etc/hibernate/tuxonice.conf",
    "/etc/hibernate/ususpend-both.conf",
    "/etc/hibernate/ususpend-disk.conf",
    "/etc/hibernate/ususpend-ram.conf",
  ]

  nl_files { $hibernate_files:
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    requires  => Package["sys-power/hibernate-script"],
    source => 'workstation',
  }

  $laptop_mode_files = [
    "/etc/acpi/actions/lm_lid.sh",
    "/etc/laptop-mode/laptop-mode.conf",
    "/etc/laptop-mode/lm-profiler.conf",
    "/etc/laptop-mode/conf.d/ac97-powersave.conf",
    "/etc/laptop-mode/conf.d/auto-hibernate.conf",
    "/etc/laptop-mode/conf.d/battery-level-polling.conf",
    "/etc/laptop-mode/conf.d/bluetooth.conf",
    "/etc/laptop-mode/conf.d/configuration-file-control.conf",
    "/etc/laptop-mode/conf.d/cpufreq.conf",
    "/etc/laptop-mode/conf.d/dpms-standby.conf",
    "/etc/laptop-mode/conf.d/eee-superhe.conf",
    "/etc/laptop-mode/conf.d/ethernet.conf",
    "/etc/laptop-mode/conf.d/exec-commands.conf",
    "/etc/laptop-mode/conf.d/hal-polling.conf",
    "/etc/laptop-mode/conf.d/intel-hda-powersave.conf",
    "/etc/laptop-mode/conf.d/intel-sata-powermgmt.conf",
    "/etc/laptop-mode/conf.d/lcd-brightness.conf",
    "/etc/laptop-mode/conf.d/nmi-watchdog.conf",
    "/etc/laptop-mode/conf.d/pcie-aspm.conf",
    "/etc/laptop-mode/conf.d/runtime-pm.conf",
    "/etc/laptop-mode/conf.d/sched-mc-power-savings.conf",
    "/etc/laptop-mode/conf.d/sched-smt-power-savings.conf",
    "/etc/laptop-mode/conf.d/start-stop-programs.conf",
    "/etc/laptop-mode/conf.d/terminal-blanking.conf",
    "/etc/laptop-mode/conf.d/usb-autosuspend.conf",
    "/etc/laptop-mode/conf.d/video-out.conf",
    "/etc/laptop-mode/conf.d/wireless-ipw-power.conf",
    "/etc/laptop-mode/conf.d/wireless-iwl-power.conf",
    "/etc/laptop-mode/conf.d/wireless-power.conf",
  ]

  nl_files { $laptop_mode_files:
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    requires  => Package["app-laptop/laptop-mode-tools"],
    source => 'workstation',
  }

  $privoxy_files = [
    "/etc/privoxy/config",
    "/etc/privoxy/default.action",
    "/etc/privoxy/default.filter",
    "/etc/privoxy/match-all.action",
    "/etc/privoxy/trust",
    "/etc/privoxy/user.action",
    "/etc/privoxy/user.filter",
  ]

  nl_files { $privoxy_files:
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    requires  => Package["net-proxy/privoxy"],
    source => 'workstation',
  }

  $pulse_files = [
    "/etc/pulse/client.conf",
    "/etc/pulse/daemon.conf",
    "/etc/pulse/default.pa",
    "/etc/pulse/system.pa",
  ]

  nl_files { $pulse_files:
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    requires  => Package["media-sound/pulseaudio"],
    source => 'workstation',
  }

  file { "/etc/X11/xorg.conf.d/30-keyboard.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    require => File['/etc/X11/xorg.conf.d'],
    path    => "/etc/X11/xorg.conf.d/30-keyboard.conf",
    source  => "puppet:///files/workstation/etc/X11/xorg.conf.d/30-keyboard.conf",
  }

  file { "/etc/cron.daily/mlocate":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0755,
    require => File['/etc/cron.daily'],
    path    => "/etc/cron.daily/mlocate",
    source  => "puppet:///files/workstation/etc/cron.daily/mlocate",
  }

  file { "/etc/irssi.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/irssi.conf",
    source => "puppet:///files/workstation/etc/irssi.conf",
  }

  file { "/etc/elinks":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/elinks/elinks.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/elinks/elinks.conf",
    source  => "puppet:///files/workstation/etc/elinks/elinks.conf",
    require => File["/etc/elinks"],
  }

  file { "/etc/portage/package.env/xautolock":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.env'],
    path => "/etc/portage/package.env/xautolock",
    source => "puppet:///files/workstation/etc/portage/package.env/xautolock",
  }

  file { "/etc/portage/package.accept_keywords/cava":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/cava",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/cava",
  }

  file { "/etc/portage/package.accept_keywords/chrome":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/chrome",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/chrome",
  }

  file { "/etc/portage/package.accept_keywords/dunst":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/dunst",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/dunst",
  }

  file { "/etc/portage/package.accept_keywords/easystroke":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/easystroke",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/easystroke",
  }

  file { "/etc/portage/package.accept_keywords/gpg":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/gpg",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/gpg",
  }

  file { "/etc/portage/package.accept_keywords/i2p":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/i2p",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/i2p",
  }

  file { "/etc/portage/package.accept_keywords/kino":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/kino",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/kino",
  }

  file { "/etc/portage/package.accept_keywords/ledger":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/ledger",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/ledger",
  }

  file { "/etc/portage/package.accept_keywords/mutt":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/mutt",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/mutt",
  }

  # file { "/etc/portage/package.accept_keywords/skype":
  #   ensure => present,
  #   owner => "root",
  #   group => "root",
  #   require => File['/etc/portage/package.accept_keywords'],
  #   path => "/etc/portage/package.accept_keywords/skype",
  #   source => "puppet:///files/workstation/etc/portage/package.accept_keywords/skype",
  # }

  file { "/etc/portage/package.accept_keywords/spotify":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/spotify",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/spotify",
  }

  file { "/etc/portage/package.accept_keywords/tor":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/tor",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/tor",
  }

  file { "/etc/portage/package.accept_keywords/wm":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/wm",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/wm",
  }

  file { "/etc/portage/package.accept_keywords/zathura":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/zathura",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/zathura",
  }

  file { "/etc/portage/package.accept_keywords/zsh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/zsh",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/zsh",
  }

  file { "/etc/portage/package.license/adobe-flash":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.license'],
    path => "/etc/portage/package.license/adobe-flash",
    source => "puppet:///files/workstation/etc/portage/package.license/adobe-flash",
  }

  # file { "/etc/portage/package.license/skype":
  #   ensure => present,
  #   owner => "root",
  #   group => "root",
  #   require => File['/etc/portage/package.license'],
  #   path => "/etc/portage/package.license/skype",
  #   source => "puppet:///files/workstation/etc/portage/package.license/skype",
  # }

  file { "/etc/portage/package.use/bitlbee":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/bitlbee",
    source => "puppet:///files/workstation/etc/portage/package.use/bitlbee",
  }

  file { "/etc/portage/package.use/calibre":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/calibre",
    source => "puppet:///files/workstation/etc/portage/package.use/calibre",
  }

  file { "/etc/portage/package.use/cups":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/cups",
    source => "puppet:///files/workstation/etc/portage/package.use/cups",
  }

  file { "/etc/portage/package.use/dunst":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/dunst",
    source => "puppet:///files/workstation/etc/portage/package.use/dunst",
  }

  file { "/etc/portage/package.use/fortune-mod":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/fortune-mod",
    source => "puppet:///files/workstation/etc/portage/package.use/fortune-mod",
  }

  file { "/etc/portage/package.use/imagemagick":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/imagemagick",
    source => "puppet:///files/workstation/etc/portage/package.use/imagemagick",
  }

  file { "/etc/portage/package.use/inkscape":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/inkscape",
    source => "puppet:///files/workstation/etc/portage/package.use/inkscape",
  }

  file { "/etc/portage/package.use/laptop-mode-tools":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/laptop-mode-tools",
    source => "puppet:///files/workstation/etc/portage/package.use/laptop-mode-tools",
  }

  file { "/etc/portage/package.use/libreoffice":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/libreoffice",
    source => "puppet:///files/workstation/etc/portage/package.use/libreoffice",
  }

  file { "/etc/portage/package.use/mupdf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/mupdf",
    source => "puppet:///files/workstation/etc/portage/package.use/mupdf",
  }

  file { "/etc/portage/package.use/pulseaudio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/pulseaudio",
    source => "puppet:///files/workstation/etc/portage/package.use/pulseaudio",
  }

  file { "/etc/portage/package.use/rtorrent":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/rtorrent",
    source => "puppet:///files/workstation/etc/portage/package.use/rtorrent",
  }

  # file { "/etc/portage/package.use/skype":
  #   ensure => present,
  #   owner => "root",
  #   group => "root",
  #   require => File['/etc/portage/package.use'],
  #   path => "/etc/portage/package.use/skype",
  #   source => "puppet:///files/workstation/etc/portage/package.use/skype",
  # }

  file { "/etc/portage/package.use/spotify":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/spotify",
    source => "puppet:///files/workstation/etc/portage/package.use/spotify",
  }

  file { "/etc/portage/package.use/tp_smapi":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/tp_smapi",
    source => "puppet:///files/workstation/etc/portage/package.use/tp_smapi",
  }

  file { "/etc/portage/package.use/vlc":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/vlc",
    source => "puppet:///files/workstation/etc/portage/package.use/vlc",
  }

  file { "/etc/portage/package.use/wm":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/wm",
    source => "puppet:///files/workstation/etc/portage/package.use/wm",
  }

  file { "/etc/portage/package.unmask/cava":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.unmask'],
    path => "/etc/portage/package.unmask/cava",
    source => "puppet:///files/workstation/etc/portage/package.unmask/cava",
  }

  # file { "/etc/portage/package.unmask/skype":
  #   ensure => present,
  #   owner => "root",
  #   group => "root",
  #   require => File['/etc/portage/package.unmask'],
  #   path => "/etc/portage/package.unmask/skype",
  #   source => "puppet:///files/workstation/etc/portage/package.unmask/skype",
  # }

  file { "/etc/portage/package.unmask/virtualbox":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.unmask'],
    path => "/etc/portage/package.unmask/virtualbox",
    source => "puppet:///files/workstation/etc/portage/package.unmask/virtualbox",
  }

  file { "/etc/tor/torrc":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/tor/torrc",
    source  => "puppet:///files/workstation/etc/tor/torrc",
    require => Package['net-misc/tor'],
  }

  file { "/etc/torsocks.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/torsocks.conf",
    source  => "puppet:///files/workstation/etc/torsocks.conf",
    require => Package['net-proxy/torsocks'],
  }

  file { "/etc/acpi/events/default":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/acpi/events/default",
    source => "puppet:///files/workstation/etc/acpi/events/default",
  }

  file { "/usr/local/bin/toggle-bluetooth":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/toggle-bluetooth",
    source => "puppet:///files/workstation/usr/local/bin/toggle-bluetooth",
  }

  file { "/usr/local/bin/60ito24p":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/60ito24p",
    source => "puppet:///files/workstation/usr/local/bin/60ito24p",
  }

  file { "/usr/local/bin/pipe-x264":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/pipe-x264",
    source => "puppet:///files/workstation/usr/local/bin/pipe-x264",
  }

  file { "/usr/local/bin/multiplex":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/multiplex",
    source => "puppet:///files/workstation/usr/local/bin/multiplex",
  }

  file { "/usr/local/bin/x86-gentoo":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/x86-gentoo",
    source => "puppet:///files/workstation/usr/local/bin/x86-gentoo",
  }

  file { "/etc/udev/hdaps-joy.rules":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/udev/hdaps-joy.rules",
    source => "puppet:///files/workstation/etc/udev/hdaps-joy.rules",
  }

  file { '/etc/udev/rules.d/z60_hdaps-joy.rules':
     ensure  => 'link',
     target  => '/etc/udev/hdaps-joy.rules',
     require => File['/etc/udev/hdaps-joy.rules'],
  }

  file { "/var/lib/nitelite/workstation":
    ensure => 'directory',
    mode    => 0755,
    require => File["/var/lib/nitelite"],
  }

  vcsrepo { "/var/lib/nitelite/workstation/picospeaker":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/byronsanchez/picospeaker.git',
    require  => File["/var/lib/nitelite/workstation"],
  }

  file { '/usr/local/bin/picospeaker':
     ensure  => 'link',
     target  => "/var/lib/nitelite/workstation/picospeaker/picospeaker",
     require => Vcsrepo["/var/lib/nitelite/workstation/picospeaker"],
  }

  # TODO: install packer
  $packages = [
    "gifsicle",
    "rfkill",
    "app-backup/tarsnap",
    "app-laptop/laptop-mode-tools",
    "app-office/ledger",
    "app-emulation/docker",
    "app-text/calibre",
    "net-wireless/bluez",
    "sys-apps/dbus",
    "app-laptop/tp_smapi",
    "app-laptop/hdapsd",
    "sys-fs/cryptsetup",
    "adobe-flash",
    "grc",
    "elinks",
    "lynx",
    "www-client/links",
    "www-client/w3m",
    "aview",
    "fbida",
    "fim",
    "feh",
    "libcaca",
    "aalib",
    "clockywock",
    "tty-clock",
    "cmatrix",
    "rtorrent",
    "axel",
    "imagemagick",
    "optipng",
    "exiftool",
    "fbreader",
    "irssi",
    "weechat",
    "bitlbee",
    # "skype",
    "pyyaml",
    "lxml",
    "mupdf",
    "libreoffice",
    "app-officeext/languagetool",
    "offlineimap",
    "msmtp",
    "notmuch",
    "urlview",
    "vagrant",
    "dev-python/keyring",
    "filezilla",
    "go",
    "sbcl",
    #"scala",
    "lua",
    #"haskell-platform",
    "pwgen",
    "fortune-mod",
    "cowsay",
    "vlc",
    "app-shells/zsh",
    "wpa_supplicant",
    "pcmciautils",
    "mlocate",
    "xmodmap",
    "xsetroot",
    "xrandr",
    "qrencode",
    "paperkey",
    "net-print/cups",
    "sys-power/powertop",
    "sys-power/hibernate-script",
    "sys-power/suspend",
    "net-dialup/minicom",
    "media-video/dvgrab",
    "media-video/kino",
    "media-video/cinelerra",
    "media-video/projectx",
    "media-video/x264-encoder",
    "media-gfx/gimp",
    "media-gfx/gimp-arrow-brushes",
    "app-doc/gimp-help",
    "media-gfx/inkscape",
    "media-gfx/evoluspencil",
    "google-chrome",
    "spotify",
    "sys-power/acpi",
    "x11-misc/dunst",
    "x11-misc/tinynotify-send",
    "app-office/scribus",
    "setxkbmap",
    "app-misc/gtypist",
    "dev-util/android-studio",
    "mesa-progs",
    "x11-wm/bspwm",
    "x11-misc/sxhkd",
    "x11-misc/xdo",
    "x11-misc/xdotool",
    "media-gfx/scrot",
    "x11-misc/i3lock",
    "x11-misc/xautolock",
    "x11-base/xorg-server",
    "net-misc/tor",
    "net-misc/i2pd",
    "net-proxy/privoxy",
    "net-im/pidgin",
    "net-ftp/filezilla",
    "media-gfx/blender",
    "net-proxy/torsocks",
    "app-misc/ranger",
    "x11-apps/xrefresh",
    "app-misc/gcal",
    "app-misc/task",
    "media-sound/pulseaudio",
    "media-sound/pavucontrol",
    "media-sound/paprefs",
    "net-misc/freerdp",
    "sys-fs/encfs",
    "media-sound/cava",
    "x11-apps/xfontsel",
    "x11-misc/easystroke",
    "net-news/newsbeuter",
    "media-gfx/comix",
    "app-text/zathura",
    "app-text/zathura-pdf-mupdf",
    "app-text/zathura-djvu",
    "media-sound/easytag",
    "sys-apps/bleachbit",
    "x11-misc/unclutter",
    "x11-apps/xbacklight",
    "x11-misc/wmctrl",
  ]

  $packages_require = [
    File["/etc/portage/package.accept_keywords/cava"],
    File["/etc/portage/package.accept_keywords/chrome"],
    File["/etc/portage/package.accept_keywords/dunst"],
    File["/etc/portage/package.accept_keywords/easystroke"],
    File["/etc/portage/package.accept_keywords/gpg"],
    File["/etc/portage/package.accept_keywords/i2p"],
    File["/etc/portage/package.accept_keywords/kino"],
    File["/etc/portage/package.accept_keywords/ledger"],
    File["/etc/portage/package.accept_keywords/mutt"],
    # File["/etc/portage/package.accept_keywords/skype"],
    File["/etc/portage/package.accept_keywords/spotify"],
    File["/etc/portage/package.accept_keywords/tor"],
    File["/etc/portage/package.accept_keywords/wm"],
    File["/etc/portage/package.accept_keywords/zathura"],
    File["/etc/portage/package.accept_keywords/zsh"],
    File["/etc/portage/package.license/adobe-flash"],
    # File["/etc/portage/package.license/skype"],
    File["/etc/portage/package.use/bitlbee"],
    File["/etc/portage/package.use/calibre"],
    File["/etc/portage/package.use/cups"],
    File["/etc/portage/package.use/dunst"],
    File["/etc/portage/package.use/fortune-mod"],
    File["/etc/portage/package.use/imagemagick"],
    File["/etc/portage/package.use/inkscape"],
    File["/etc/portage/package.use/laptop-mode-tools"],
    File["/etc/portage/package.use/libreoffice"],
    File["/etc/portage/package.use/mupdf"],
    File["/etc/portage/package.use/pulseaudio"],
    File["/etc/portage/package.use/rtorrent"],
    # File["/etc/portage/package.use/skype"],
    File["/etc/portage/package.use/spotify"],
    File["/etc/portage/package.use/tp_smapi"],
    File["/etc/portage/package.use/vlc"],
    File["/etc/portage/package.use/wm"],
    File["/etc/portage/package.unmask/cava"],
    # File["/etc/portage/package.unmask/skype"],
    File["/etc/portage/package.unmask/virtualbox"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  $packages_overlay = [
    "app-accessibility/svox",
    "media-gfx/pngout",
    "x11-misc/lighthouse",
    "x11-misc/bar",
    "x11-misc/sutils",
    "x11-misc/xtitle",
  ]

  $packages_overlay_require = [
    Layman['nitelite-a'],
    Layman['nitelite-b'],
  ]

  package { $packages_overlay:
    ensure  => installed,
    require => $packages_overlay_require,
  }

  service { privoxy:
    ensure    => running,
    enable => true,
    require   => [
      Package['net-proxy/privoxy'],
    ],
  }

  service { laptop_mode:
    ensure    => running,
    enable => true,
    require   => [
      Package['app-laptop/laptop-mode-tools'],
    ],
  }

  service { dbus:
    ensure    => running,
    enable => true,
    require   => [
      Package['sys-apps/dbus'],
    ],
  }

  service { hdapsd:
    ensure    => running,
    enable => true,
    require   => [
      Package['app-laptop/hdapsd'],
    ],
  }

  service { cupsd:
    ensure    => running,
    enable => true,
    require   => [
      Package['net-print/cups'],
      Service['avahi-daemon'],
    ],
  }

  service { bitlbee:
    ensure    => running,
    enable => true,
    require   => [
      Package['bitlbee'],
    ],
  }

}

