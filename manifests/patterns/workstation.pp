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

  file { "/etc/portage/package.use/bitlbee":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/bitlbee",
    source => "puppet:///files/workstation/etc/portage/package.use/bitlbee",
  }

  $packages = [
    "virtualbox",
    "app-emulation/docker",
    "grc",
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
    "rtorrent",
    "axel",
    "imagemagick",
    "optipng",
    "exiftool",
    "irssi",
    "weechat",
    "bitlbee",
    "skype",
    "pyyaml",
    "lxml",
    "festival",
    "sshfs-fuse",
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
  ]

  package { $packages: ensure => installed }

}
