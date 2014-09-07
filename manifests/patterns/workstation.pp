class workstation {

  file { "/etc/irssi.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/irssi.conf",
    source => "puppet:///files/workstation/etc/irssi.conf",
  }

  file { "/etc/redshift.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/redshift.conf",
    source => "puppet:///files/workstation/etc/redshift.conf",
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

  file { "/etc/portage/package.use/fortune-mod":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/fortune-mod",
    source => "puppet:///files/base/etc/portage/package.use/fortune-mod",
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
    source =>
    "puppet:///files/workstation/etc/portage/package.use/laptop-mode-tools",
  }

  file { "/etc/portage/package.use/vlc":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/vlc",
    source => "puppet:///files/workstation/etc/portage/package.use/vlc",
  }

  file { "/etc/portage/package.license/adobe-flash":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.license'],
    path => "/etc/portage/package.license/adobe-flash",
    source =>
    "puppet:///files/workstation/etc/portage/package.license/adobe-flash",
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

  # TODO: install packer
  $packages = [
    "app-laptop/laptop-mode-tools",
    "app-office/ledger",
    "app-emulation/virtualbox",
    "app-emulation/docker",
    "app-text/calibre",
    "net-wireless/bluez",
    "sys-apps/dbus",
    "sys-auth/libfprint",
    "sys-auth/fprint_demo",
    "sys-auth/pam_fprint",
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
    "festival",
    "espeak",
    "mupdf",
    "libreoffice",
    "offlineimap",
    "msmtp",
    "notmuch",
    "urlview",
    "vagrant",
    "dev-python/keyring",
    "vlc",
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
    "zsh",
    "zsh-completion",
    "wpa_supplicant",
  ]

  package { $packages: ensure => installed }

  service { dbus:
    ensure    => running,
    enable => true,
    require   => [
      Package['sys-apps/dbus'],
    ],
  }

}
