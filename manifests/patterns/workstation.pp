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

  file { "/etc/portage/package.accept_keywords/lxappearance-obconf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/lxappearance-obconf",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/lxappearance-obconf",
  }

  file { "/etc/portage/package.accept_keywords/gpg":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/gpg",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/gpg",
  }

  file { "/etc/portage/package.accept_keywords/zsh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/zsh",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/zsh",
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

  file { "/etc/portage/package.use/rtorrent":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/rtorrent",
    source => "puppet:///files/workstation/etc/portage/package.use/rtorrent",
  }

  file { "/etc/portage/package.use/bitlbee":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/bitlbee",
    source => "puppet:///files/workstation/etc/portage/package.use/bitlbee",
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

  file { "/etc/portage/package.use/imagemagick":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/imagemagick",
    source => "puppet:///files/workstation/etc/portage/package.use/imagemagick",
  }

  file { "/etc/portage/package.use/calibre":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/calibre",
    source => "puppet:///files/workstation/etc/portage/package.use/calibre",
  }

  file { "/etc/portage/package.use/laptop-mode-tools":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/laptop-mode-tools",
    source => "puppet:///files/workstation/etc/portage/package.use/laptop-mode-tools",
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

  file { "/etc/portage/package.use/inkscape":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/inkscape",
    source => "puppet:///files/workstation/etc/portage/package.use/inkscape",
  }

  file { "/etc/portage/package.license/adobe-flash":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.license'],
    path => "/etc/portage/package.license/adobe-flash",
    source => "puppet:///files/workstation/etc/portage/package.license/adobe-flash",
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
    "pcmanfm",
    "gentoo",
    "app-backup/tarsnap",
    "app-laptop/laptop-mode-tools",
    "app-office/ledger",
    "app-emulation/virtualbox",
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
    "skype",
    "pyyaml",
    "lxml",
    "mupdf",
    "libreoffice",
    "appoffice-ext/languagetool",
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
    "x11-wm/openbox",
    "x11-misc/obconf",
    "lxde-base/lxappearance-obconf",
    "setxkbmap",
    "app-misc/gtypist",
    "dev-util/android-studio",
  ]

  package { $packages: ensure => installed }

  $packages_overlay = [
    "app-accessibility/svox",
    "media-gfx/pngout",
    "net-print/cupswrapper-brother-hl2270dw-2.0.4",
    "net-print/lpdfilter-brother-hl2270dw-2.1.0",
  ]

  package { $packages_overlay:
    ensure  => installed,
    require => [
      Layman['nitelite-a'],
      Layman['nitelite-b'],
    ],
  }

  layman { 'unity-gentoo':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
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

