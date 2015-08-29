class xorgserver (
  $xorg_driver,
  $xorg_busid,
  $xorg_type = "",
) {

  nl_homedir::file { "staff_xsession":
    file  => ".xsession",
    user => "staff",
    mode => 0644,
    owner   => 'staff',
    group   => 'staff',
  }

  file { "/etc/X11":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/X11/xorg.conf.d":
    ensure => "directory",
    owner => "root",
    group => "root",
    require => File['/etc/X11'],
  }

  file { "/etc/X11/xorg.conf.d/40-monitor.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    require => File['/etc/X11/xorg.conf.d'],
    content => template("xorg-server/etc/X11/xorg.conf.d/40-monitor.conf.erb"),
    path => "/etc/X11/xorg.conf.d/40-monitor.conf",
  }

  file { "/etc/portage/package.use/compton":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/compton",
    source => "puppet:///files/xorg-server/etc/portage/package.use/compton",
  }

  file { "/etc/portage/package.use/firefox":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/firefox",
    source => "puppet:///files/xorg-server/etc/portage/package.use/firefox",
  }

  file { "/etc/portage/package.use/freetype":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/freetype",
    source => "puppet:///files/xorg-server/etc/portage/package.use/freetype",
  }

  file { "/etc/portage/package.use/rxvt-unicode":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/rxvt-unicode",
    source => "puppet:///files/xorg-server/etc/portage/package.use/rxvt-unicode",
  }

  file { "/etc/portage/package.use/xorg-server":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/xorg-server",
    source => "puppet:///files/xorg-server/etc/portage/package.use/xorg-server",
  }

  file { "/etc/fonts/51-local.conf":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/fonts/51-local.conf",
    source => "puppet:///files/xorg-server/etc/fonts/51-local.conf",
  }

  $packages = [
    "xorg-server",
    "redshift",
    "compton",
    "rxvt-unicode",
    "urxvt-perls",
    # lib for fonts
    "libXft",
    "firefox",
    "x11-misc/xclip",
    "freetype",
    "fontconfig",
    "fontconfig-infinality",
    "corefonts",
  ]

  $packages_require = [
      File["/etc/portage/package.use/compton"],
      File["/etc/portage/package.use/firefox"],
      File["/etc/portage/package.use/freetype"],
      File["/etc/portage/package.use/rxvt-unicode"],
      File['/etc/portage/package.use/xorg-server'],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  eselect { 'infinality':
    set => 'osx',
  }

  eselect { 'lcdfilter':
    set => 'osx',
  }

  # Update environment if xorg is freshly installed
  exec { "xorg_update_environment":
    command     => "/usr/sbin/env-update && source /etc/profile",
    subscribe   => Package[xorg-server],
    refreshonly => true,
  }

}
