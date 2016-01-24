
# TODO: Skype should be in chroot only

class workstation (
  $xorg_apps = false,
  $skype = false
) {

  # TODO: paramter for browsing, axel and stuff
  # TODO: paramter for media

  if $skype {

    file { "/etc/portage/package.accept_keywords/skype":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.accept_keywords'],
      path => "/etc/portage/package.accept_keywords/skype",
      source => "puppet:///files/workstation/etc/portage/package.accept_keywords/skype",
    }

    file { "/etc/portage/package.license/skype":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.license'],
      path => "/etc/portage/package.license/skype",
      source => "puppet:///files/workstation/etc/portage/package.license/skype",
    }

    file { "/etc/portage/package.use/skype":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/skype",
      source => "puppet:///files/workstation/etc/portage/package.use/skype",
    }

    file { "/etc/portage/package.unmask/skype":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.unmask'],
      path => "/etc/portage/package.unmask/skype",
      source => "puppet:///files/workstation/etc/portage/package.unmask/skype",
    }

    $packages_skype = [
      "skype",
    ]

    $packages_skype_require = [
      File["/etc/portage/package.accept_keywords/skype"],
      File["/etc/portage/package.license/skype"],
      File["/etc/portage/package.use/skype"],
      File["/etc/portage/package.unmask/skype"],
    ]

    package { $packages_skype:
      ensure  => installed,
      require => $packages_skype_require,
    }

  }

  if $xorg_apps {

    file { "/etc/portage/package.env/xautolock":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.env'],
      path => "/etc/portage/package.env/xautolock",
      source => "puppet:///files/workstation/etc/portage/package.env/xautolock",
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

    file { "/etc/portage/package.accept_keywords/firefox":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.accept_keywords'],
      path => "/etc/portage/package.accept_keywords/firefox",
      source => "puppet:///files/workstation/etc/portage/package.accept_keywords/firefox",
    }

    file { "/etc/portage/package.accept_keywords/spotify":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.accept_keywords'],
      path => "/etc/portage/package.accept_keywords/spotify",
      source => "puppet:///files/workstation/etc/portage/package.accept_keywords/spotify",
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

    file { "/etc/portage/package.license/adobe-flash":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.license'],
      path => "/etc/portage/package.license/adobe-flash",
      source => "puppet:///files/workstation/etc/portage/package.license/adobe-flash",
    }

    file { "/etc/portage/package.use/calibre":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/calibre",
      source => "puppet:///files/workstation/etc/portage/package.use/calibre",
    }

    file { "/etc/portage/package.use/compton":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/compton",
      source => "puppet:///files/workstation/etc/portage/package.use/compton",
    }

    file { "/etc/portage/package.use/dunst":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/dunst",
      source => "puppet:///files/workstation/etc/portage/package.use/dunst",
    }

    file { "/etc/portage/package.use/firefox":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/firefox",
      source => "puppet:///files/workstation/etc/portage/package.use/firefox",
    }

    file { "/etc/portage/package.use/inkscape":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/inkscape",
      source => "puppet:///files/workstation/etc/portage/package.use/inkscape",
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

    file { "/etc/portage/package.use/picard":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/picard",
      source => "puppet:///files/workstation/etc/portage/package.use/picard",
    }

    file { "/etc/portage/package.use/spotify":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/spotify",
      source => "puppet:///files/workstation/etc/portage/package.use/spotify",
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

    file { "/etc/portage/package.unmask/virtualbox":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.unmask'],
      path => "/etc/portage/package.unmask/virtualbox",
      source => "puppet:///files/workstation/etc/portage/package.unmask/virtualbox",
    }

    $packages_xorg = [
      "sys-apps/dbus",
      "feh",
      "media-sound/picard",
      "musicbrainz",
      "redshift",
      "compton",
      "firefox",
      "x11-misc/xclip",
      "net-misc/tigervnc",
      "app-text/calibre",
      "adobe-flash",
      "fbreader",
      "mupdf",
      "libreoffice",
      "app-officeext/languagetool",
      "filezilla",
      "vlc",
      "xmodmap",
      "xsetroot",
      "xrandr",
      "media-gfx/gimp",
      "media-gfx/gimp-arrow-brushes",
      "app-doc/gimp-help",
      "media-gfx/inkscape",
      "media-gfx/evoluspencil",
      "google-chrome",
      "spotify",
      "x11-misc/dunst",
      "x11-misc/tinynotify-send",
      "app-office/scribus",
      "setxkbmap",
      "dev-util/android-studio",
      "x11-wm/bspwm",
      "x11-misc/sxhkd",
      "x11-misc/xdo",
      "x11-misc/xdotool",
      "media-gfx/scrot",
      "x11-misc/i3lock",
      "x11-misc/xautolock",
      "net-im/pidgin",
      "net-ftp/filezilla",
      "media-gfx/blender",
      "x11-apps/xrefresh",
      "net-misc/freerdp",
      "media-gfx/comix",
      "app-text/zathura",
      "app-text/zathura-pdf-mupdf",
      "app-text/zathura-djvu",
      "x11-misc/unclutter",
      "x11-apps/xbacklight",
      "x11-misc/wmctrl",
      "x11-apps/xfontsel",
      "x11-misc/easystroke",
      "mesa-progs",
    ]

    $packages_xorg_require = [
      File["/etc/portage/package.accept_keywords/chrome"],
      File["/etc/portage/package.accept_keywords/dunst"],
      File["/etc/portage/package.accept_keywords/easystroke"],
      File["/etc/portage/package.accept_keywords/spotify"],
      File["/etc/portage/package.accept_keywords/wm"],
      File["/etc/portage/package.accept_keywords/zathura"],
      File["/etc/portage/package.license/adobe-flash"],
      File["/etc/portage/package.use/calibre"],
      File["/etc/portage/package.use/compton"],
      File["/etc/portage/package.use/dunst"],
      File["/etc/portage/package.use/firefox"],
      File["/etc/portage/package.use/inkscape"],
      File["/etc/portage/package.use/libreoffice"],
      File["/etc/portage/package.use/mupdf"],
      File["/etc/portage/package.use/picard"],
      File["/etc/portage/package.use/spotify"],
      File["/etc/portage/package.use/wm"],
      File["/etc/portage/package.unmask/virtualbox"],
      File["/etc/portage/package.use/vlc"],
    ]

    package { $packages_xorg:
      ensure  => installed,
      require => $packages_xorg_require,
    }

    $packages_overlay_xorg = [
      "x11-misc/lighthouse",
      "x11-misc/bar",
      "x11-misc/sutils",
      "x11-misc/xtitle",
    ]

    $packages_overlay_xorg_require = [
      Layman['nitelite-a'],
      Layman['nitelite-b'],
    ]

    package { $packages_overlay_xorg:
      ensure  => installed,
      require => $packages_overlay_xorg_require,
    }

    service { dbus:
      ensure    => running,
      enable => true,
      require   => [
        Package['sys-apps/dbus'],
      ],
    }

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

  file { "/etc/portage/package.accept_keywords/ffmpeg":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/ffmpeg",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/ffmpeg",
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

  file { "/etc/portage/package.accept_keywords/ledger":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/ledger",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/ledger",
  }

  file { "/etc/portage/package.accept_keywords/mplayer":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/mplayer",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/mplayer",
  }

  file { "/etc/portage/package.accept_keywords/mutt":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/mutt",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/mutt",
  }

  file { "/etc/portage/package.accept_keywords/tor":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/tor",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/tor",
  }

  file { "/etc/portage/package.accept_keywords/zsh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/zsh",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/zsh",
  }

  file { "/etc/portage/package.use/bitlbee":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/bitlbee",
    source => "puppet:///files/workstation/etc/portage/package.use/bitlbee",
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

  file { "/usr/local/bin/x86-gentoo":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/x86-gentoo",
    source => "puppet:///files/workstation/usr/local/bin/x86-gentoo",
  }

  file { "/var/lib/nitelite/workstation":
    ensure => 'directory',
    mode    => 0755,
    require => File["/var/lib/nitelite"],
  }

  ### new stuff

  file { "/etc/portage/package.accept_keywords/cava":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/cava",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/cava",
  }

  file { "/etc/portage/package.unmask/cava":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.unmask'],
    path => "/etc/portage/package.unmask/cava",
    source => "puppet:///files/workstation/etc/portage/package.unmask/cava",
  }

  file { "/etc/portage/package.license/fdk":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.license'],
    path => "/etc/portage/package.license/fdk",
    source => "puppet:///files/workstation/etc/portage/package.license/fdk",
  }

  file { "/etc/portage/package.use/ffmpeg":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/ffmpeg",
    source => "puppet:///files/workstation/etc/portage/package.use/ffmpeg",
  }

  file { "/etc/portage/package.use/imagemagick":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/imagemagick",
    source => "puppet:///files/workstation/etc/portage/package.use/imagemagick",
  }

  file { "/etc/portage/package.use/mpd":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/mpd",
    source => "puppet:///files/workstation/etc/portage/package.use/mpd",
  }

  file { "/etc/portage/package.use/ncmpcpp":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/ncmpcpp",
    source => "puppet:///files/workstation/etc/portage/package.use/ncmpcpp",
  }

  file { "/etc/mpd.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/mpd.conf",
    source => "puppet:///files/workstation/etc/mpd.conf",
  }

  file { "/var/lib/mpd":
    ensure => directory,
    owner => "byronsanchez",
    group => "audio",
    mode    => '644',
  }

  file { "/usr/local/lib/nitelite/mp3-duration.fmt":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/usr/local/lib/nitelite'],
    path => "/usr/local/lib/nitelite/mp3-duration.fmt",
    source => "puppet:///files/workstation/usr/local/lib/nitelite/mp3-duration.fmt",
  }

  file { "/usr/local/bin/mp3-clean":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/mp3-clean",
    source => "puppet:///files/workstation/usr/local/bin/mp3-clean",
  }

  file { "/usr/local/bin/mp3-validate":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/mp3-validate",
    source => "puppet:///files/workstation/usr/local/bin/mp3-validate",
  }

  file { "/usr/local/bin/playlist-scan":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/playlist-scan",
    source => "puppet:///files/workstation/usr/local/bin/playlist-scan",
  }

  file { "/usr/local/bin/playlist-checkout":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/playlist-checkout",
    source => "puppet:///files/workstation/usr/local/bin/playlist-checkout",
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
  # TODO: Consider splitting up user-specific packages to dotfiles. Will require
  # mangement of portage config files (use, keywords, etc.); This pattern will 
  # only contain lower-level stuff like hardware configs, xorg, etc. User-level 
  # stuff will be moved to dotfiles to match homebrew and chocolatey.
  $packages = [
    "dev-python/pip",
    "app-backup/tarsnap",
    "app-office/ledger",
    # "app-emulation/docker",
    "sys-fs/cryptsetup",
    "grc",
    "elinks",
    "lynx",
    "www-client/links",
    "www-client/w3m",
    "aview",
    "fbida",
    "fim",
    "libcaca",
    "aalib",
    "clockywock",
    "tty-clock",
    "cmatrix",
    "rtorrent",
    "axel",
    "irssi",
    "weechat",
    "bitlbee",
    "pyyaml",
    "lxml",
    "offlineimap",
    "msmtp",
    "notmuch",
    "urlview",
    "vagrant",
    "dev-python/keyring",
    "go",
    # "sbcl",
    # "scala",
    "lua",
    #"haskell-platform",
    "pwgen",
    "fortune-mod",
    "cowsay",
    "app-shells/zsh",
    "mlocate",
    "qrencode",
    "paperkey",
    "sys-power/powertop",
    "sys-power/acpi",
    "app-misc/gtypist",
    "net-misc/tor",
    "net-misc/i2pd",
    "net-proxy/privoxy",
    "net-proxy/torsocks",
    "app-misc/ranger",
    "app-misc/gcal",
    "app-misc/task",
    "sys-fs/encfs",
    "net-news/newsbeuter",
    "sys-apps/bleachbit",
    "sys-fs/dosfstools",
    "mpd",
    "media-sound/mpc",
    "ncmpcpp",
    "id3lib",
    "mp3check",
    "mplayer",
    "cpuinfo2cpuflags",
    "media-sound/easytag",
    "gifsicle",
    "imagemagick",
    "optipng",
    "exiftool",
    "media-sound/cava",
    # required by picospeaker
    "media-sound/sox",
  ]

  $packages_require = [
    File["/etc/portage/package.accept_keywords/cava"],
    File["/etc/portage/package.accept_keywords/gpg"],
    File["/etc/portage/package.accept_keywords/i2p"],
    File["/etc/portage/package.accept_keywords/ledger"],
    File["/etc/portage/package.accept_keywords/mplayer"],
    File["/etc/portage/package.accept_keywords/mutt"],
    File["/etc/portage/package.accept_keywords/tor"],
    File["/etc/portage/package.accept_keywords/zsh"],
    File["/etc/portage/package.license/fdk"],
    File["/etc/portage/package.unmask/cava"],
    File["/etc/portage/package.use/bitlbee"],
    File["/etc/portage/package.use/ffmpeg"],
    File["/etc/portage/package.use/fortune-mod"],
    File["/etc/portage/package.use/imagemagick"],
    File["/etc/portage/package.use/mpd"],
    File["/etc/portage/package.use/ncmpcpp"],
    File["/etc/portage/package.use/rtorrent"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  $pip_packages = [
    "virtualenv",
  ]

  package { $pip_packages:
    ensure  => installed,
    provider => 'pip',
    require => [
      Eselect[python],
    ],
  }

  $packages_overlay = [
    "media-gfx/pngout",
    "app-accessibility/svox",
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

  service { bitlbee:
    ensure    => running,
    enable => true,
    require   => [
      Package['bitlbee'],
    ],
  }

  service { 'mpd':
    ensure => running,
    enable => true,
    subscribe => File['/etc/mpd.conf'],
    require   => [
      File['/etc/mpd.conf'],
      Package[mpd],
    ],
  }

}

