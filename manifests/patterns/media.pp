class media {

  # TODO: For all classes, ensure that the use flags and other portage package
  # files are depended on by the corresponding packages.

  file { "/etc/portage/package.use/mpd":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/mpd",
    source => "puppet:///files/media/etc/portage/package.use/mpd",
  }

  file { "/etc/portage/package.use/ncmpcpp":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/ncmpcpp",
    source => "puppet:///files/media/etc/portage/package.use/ncmpcpp",
  }

  file { "/etc/portage/package.use/picard":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/picard",
    source => "puppet:///files/media/etc/portage/package.use/picard",
  }

  file { "/etc/mpd.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/mpd.conf",
    source => "puppet:///files/media/etc/mpd.conf",
  }

  file { "/var/lib/mpd":
    ensure => directory,
    owner => "mpd",
    group => "audio",
    mode    => '644',
  }

  $packages = [
    "mpd",
    "media-sound/mpc",
    "ncmpcpp",
    "alsa-utils",
    "alsaequal",
    "id3lib",
    "mp3check",
    "media-sound/picard",
    "mplayer",
  ]

  package { $packages: ensure => installed }

  service { 'mpd':
    ensure => running,
    enable => true,
    subscribe => File['/etc/mpd.conf'],
    require   => [
      File['/etc/mpd.conf'],
      Package[mpd],
    ],
  }

  service { 'alsasound':
    ensure => running,
    enable => true,
    require   => [
      Package[alsa-utils],
    ],
  }

}
