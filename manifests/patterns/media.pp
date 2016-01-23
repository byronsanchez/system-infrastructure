class media {

  # TODO: For all classes, ensure that the use flags and other portage package
  # files are depended on by the corresponding packages.

  user { 'realtime':
    ensure => 'present',
    gid    => '1017',
    shell  => '/bin/false',
    uid    => '1017',
  }

  group { 'realtime':
    ensure => 'present',
    gid    => '1017',
  }

  # pulse is used for cava audio visualization and skype
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
    source => 'media',
  }

  file { "/etc/asound.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/asound.conf",
    source => "puppet:///files/media/etc/asound.conf",
  }

  file { "/etc/conf.d/jackd":
    ensure => present,
    mode => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/media/etc/conf.d/jackd",
  }

  file { "/etc/security/limits.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/security/limits.conf",
    source => "puppet:///files/media/etc/security/limits.conf",
  }

  file { "/etc/portage/package.accept_keywords/gentoo-studio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/gentoo-studio",
    source => "puppet:///files/media/etc/portage/package.accept_keywords/gentoo-studio",
  }

  file { "/etc/portage/package.use/gentoo-studio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/gentoo-studio",
    source => "puppet:///files/media/etc/portage/package.use/gentoo-studio",
  }

  file { "/etc/portage/package.use/pulseaudio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/pulseaudio",
    source => "puppet:///files/media/etc/portage/package.use/pulseaudio",
  }

  file { "/usr/local/bin/loop2jack":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/loop2jack",
    source => "puppet:///files/media/usr/local/bin/loop2jack",
  }

  # TODO: Set the firewire device paths in the file. one line per firewire device
  # to find path, hook up the device, and look in /dev/fw*
  file { "/etc/udev/rules.d/fw.rules":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/udev/rules.d/fw.rules",
    source => "puppet:///files/media/etc/udev/rules.d/fw.rules",
  }

  file { "/etc/portage/package.accept_keywords/kino":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/kino",
    source => "puppet:///files/media/etc/portage/package.accept_keywords/kino",
  }

  file { "/usr/local/bin/60ito24p":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/60ito24p",
    source => "puppet:///files/media/usr/local/bin/60ito24p",
  }

  file { "/usr/local/bin/pipe-x264":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/pipe-x264",
    source => "puppet:///files/media/usr/local/bin/pipe-x264",
  }

  file { "/usr/local/bin/multiplex":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/multiplex",
    source => "puppet:///files/media/usr/local/bin/multiplex",
  }

  $packages = [
    "alsa-utils",
    "alsaequal",
    "alsa-oss",
    "alsa-plugins",
    "media-video/dvgrab",
    "media-video/kino",
    "media-video/cinelerra",
    "media-video/projectx",
    "media-video/x264-encoder",
    "media-sound/pulseaudio",
    "media-sound/pavucontrol",
    "media-sound/paprefs",
  ]

  $packages_require = [
    File["/etc/portage/package.accept_keywords/kino"],
    File["/etc/portage/package.use/pulseaudio"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  # TODO: This is stale, update with most recent
  $gentoo_studio_packages = [
    "a2jmidid",
    "gscanbus",
    "qjackctl",
    "jack-keyboard",
    "jackd-init",
    "dss",
    "i-vst",
    "ardour",
    "rosegarden",
    "audacity",
    "nekobee",
    "omins",
    "blop",
    "calf",
    "eq10q",
    "hexter",
    "invada-studio-plugins",
    "invada-studio-plugins-lv2",
    "ll-plugins",
    "lv2fil",
    "njl-plugins",
    "rev-plugins",
    "swh-plugins",
    "tap-plugins",
    "vcf",
    "vocoder-ladspa",
    "wah-plugins",
    "wasp",
    "xsynth-dssi",
    "amsynth",
    "bristol",
    "hydrogen",
    "jack-rack",
    "minicomputer",
    "mx44",
    "paulstretch",
    "psindustrializer",
    "qmidiroute",
    "qtractor",
    "rakarrack",
    "rtsynth",
    "seq24",
    "yoshimi",
    "zynaddsubfx",
  ]

  $gentoo_studio_packages_require = [
    Layman['proaudio'],
    File["/etc/portage/package.accept_keywords/gentoo-studio"],
    File["/etc/portage/package.use/gentoo-studio"],
  ]

  package { $gentoo_studio_packages:
    ensure  => installed,
    require => $gentoo_studio_packages_require,
  }

  layman { 'proaudio':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  service { 'alsasound':
    ensure => running,
    enable => true,
    require   => [
      Package[alsa-utils],
    ],
  }

}

