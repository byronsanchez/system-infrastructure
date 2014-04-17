class workstation {

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

  file { "/etc/portage/package.use/rtorrent":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/rtorrent",
    source => "puppet:///files/workstation/etc/portage/package.use/rtorrent",
  }

  file { "/etc/portage/package.accept_keywords/truecrypt":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/truecrypt",
    source => "puppet:///files/workstation/etc/portage/package.accept_keywords/truecrypt",
  }

  $packages = [
    "conky",
    "elinks",
    "lynx",
    "aview",
    "fbida",
    "fim",
    "libcaca",
    "aalib",
    "clockywock",
    "tty-clock",
    "cmatrix",
    #"tesseract"
    "rtorrent",
    "axel",
    "imagemagick",
    "optipng",
    "exiftool",
    "irssi",
    "weechat",
    "pyyaml",
    "lxml",
    "festival",
    "keepassx",
    "truecrypt",
    "sshfs-fuse",
  ]

  package { $packages: ensure => installed }

}
