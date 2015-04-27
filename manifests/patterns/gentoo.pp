class gentoo(
  $use_flags = '',
  $cpu_flags = '',
  $linguas = '',
  $video_cards = '',
  $input_devices = '',
  $lowmemorybox = false,
  $environment = '',
) {

  file { "/etc/portage/make.conf":
    ensure => present,
    path => "/etc/portage/make.conf",
    owner => "root",
    group => "root",
    content => template("gentoo/etc/portage/make.conf.erb"),
  }

  file { "/etc/portage/repos.conf":
    ensure => present,
    path => "/etc/portage/repos.conf",
    owner => "root",
    group => "root",
    content => template("gentoo/etc/portage/repos.conf.erb"),
  }

  file { "/etc/portage/bashrc.d":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/env":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/package.env":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/env/disable-sandbox":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/env'],
    path => "/etc/portage/env/disable-sandbox",
    source => "puppet:///files/gentoo/etc/portage/env/disable-sandbox",
  }

  file { "/etc/portage/package.mask":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/package.license":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/package.use":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/package.unmask":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/package.mask/systemd":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.mask'],
    path => "/etc/portage/package.mask/systemd",
    source => "puppet:///files/gentoo/etc/portage/package.mask/systemd",
  }

  file { "/etc/portage/package.mask/udev":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.mask'],
    path => "/etc/portage/package.mask/udev",
    source => "puppet:///files/gentoo/etc/portage/package.mask/udev",
  }

  file { "/etc/portage/package.use/layman":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/layman",
    source => "puppet:///files/gentoo/etc/portage/package.use/layman",
  }

  file { "/etc/portage/package.accept_keywords/overlay-nitelite":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/overlay-nitelite",
    source => "puppet:///files/gentoo/etc/portage/package.accept_keywords/overlay-nitelite",
  }

  file { "/etc/portage/patches":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/package.accept_keywords":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/portage/gpg":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 0700,
  }

  # For local overlays
  file { "/etc/layman/overlays":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  # Used to define remote overlays
  file { "/etc/layman/layman.cfg":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/layman/layman.cfg",
    source  => "puppet:///files/gentoo/etc/layman/layman.cfg",
  }

  # Have eix sync overlays too
  file { "/etc/eix-sync.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/eix-sync.conf",
    source  => "puppet:///files/gentoo/etc/eix-sync.conf",
  }


  file { "/usr/local/bin/portage-import-gpg-key":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/usr/local/bin/portage-import-gpg-key",
    source => "puppet:///files/gentoo/usr/local/bin/portage-import-gpg-key",
  }

  $packages = [
    "gentoolkit",
    "layman",
    "portage-utils",
    "eix",
    "genlop",
  ]

  $packages_require = [
    File["/etc/portage/package.use/layman"],
    File["/etc/portage/package.mask/udev"],
    Package[udev],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  # Make sure udev is uninstalled
  package { udev:
    ensure => absent,
  }

  package { eudev:
    ensure  => installed,
    require => $packages_require,
  }

  # TODO: place layman nitelite as a dep for packages that will retrieve from
  # the overlay
  layman { 'niteLite':
    ensure  => absent,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  layman { 'nitelite-a':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  layman { 'nitelite-b':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  layman { 'nitelite-applications':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  exec { "layman_sync":
    command => "/usr/bin/layman -S",
    subscribe   => File['/etc/layman/layman.cfg'],
    refreshonly => true,
  }

  exec { "create_eix_cache":
    command => "/usr/bin/eix-update",
    creates => "/var/cache/eix/portage.eix",
  }

  exec { "portage_import_gpg_key":
    command => "/usr/local/bin/portage-import-gpg-key",
    creates => "/etc/portage/gpg/pubring.gpg",
    require => File["/usr/local/bin/portage-import-gpg-key"],
  }

}
