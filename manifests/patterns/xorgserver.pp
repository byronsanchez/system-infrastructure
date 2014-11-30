class xorgserver {

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
    require => File['/etc/X11/xorg.conf.d'],
    path => "/etc/X11/xorg.conf.d/40-monitor.conf",
    source => "puppet:///files/xorg-server/etc/X11/xorg.conf.d/40-monitor.conf",
  }

  file { "/etc/portage/package.use/xorg-server":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/xorg-server",
    source => "puppet:///files/xorg-server/etc/portage/package.use/xorg-server",
  }

  file { "/etc/portage/package.use/compton":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/compton",
    source => "puppet:///files/xorg-server/etc/portage/package.use/compton",
  }

  file { "/etc/portage/package.use/rxvt-unicode":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/rxvt-unicode",
    source => "puppet:///files/xorg-server/etc/portage/package.use/rxvt-unicode",
  }

  file { "/etc/portage/package.use/firefox":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/firefox",
    source => "puppet:///files/xorg-server/etc/portage/package.use/firefox",
  }

  file { "/etc/portage/package.use/hsetroot":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/hsetroot",
    source => "puppet:///files/xorg-server/etc/portage/package.use/hsetroot",
  }

  file { "/etc/portage/package.use/freetype":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/freetype",
    source => "puppet:///files/xorg-server/etc/portage/package.use/freetype",
  }

  file { "/etc/portage/package.use/fvwm":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/fvwm",
    source => "puppet:///files/xorg-server/etc/portage/package.use/fvwm",
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
    "ratpoison",
    "x11-wm/fvwm",
    "x11-themes/fvwm-crystal",
    "redshift",
    "xbindkeys",
    "compton",
    "rxvt-unicode",
    # lib for fonts
    "libXft",
    "firefox",
    "hsetroot",
    "x11-misc/xclip",
    "freetype",
    "fontconfig",
    "fontconfig-infinality",
    "corefonts",
  ]

  package { $packages:
    ensure  => installed,
    require => [
      File['/etc/portage/package.use/xorg-server'],
    ],
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
