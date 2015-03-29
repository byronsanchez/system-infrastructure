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

  file { "/etc/portage/package.license/fdk":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.license'],
    path => "/etc/portage/package.license/fdk",
    source => "puppet:///files/media/etc/portage/package.license/fdk",
  }

  file { "/etc/portage/package.use/ffmpeg":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/ffmpeg",
    source => "puppet:///files/media/etc/portage/package.use/ffmpeg",
  }

  file { "/etc/portage/package.use/gentoo-studio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/gentoo-studio",
    source => "puppet:///files/media/etc/portage/package.use/gentoo-studio",
  }

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

  file { "/etc/asound.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/asound.conf",
    source => "puppet:///files/media/etc/asound.conf",
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
    source => "puppet:///files/media/usr/local/lib/nitelite/mp3-duration.fmt",
  }

  file { "/usr/local/bin/loop2jack":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/loop2jack",
    source => "puppet:///files/media/usr/local/bin/loop2jack",
  }

  file { "/usr/local/bin/mp3-clean":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/mp3-clean",
    source => "puppet:///files/media/usr/local/bin/mp3-clean",
  }

  file { "/usr/local/bin/mp3-validate":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/mp3-validate",
    source => "puppet:///files/media/usr/local/bin/mp3-validate",
  }

  file { "/usr/local/bin/playlist-scan":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/playlist-scan",
    source => "puppet:///files/media/usr/local/bin/playlist-scan",
  }

  file { "/usr/local/bin/playlist-checkout":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/playlist-checkout",
    source => "puppet:///files/media/usr/local/bin/playlist-checkout",
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

  $packages = [
    "mpd",
    "media-sound/mpc",
    "ncmpcpp",
    "alsa-utils",
    "alsaequal",
    "alsa-oss",
    "alsa-plugins",
    "id3lib",
    "mp3check",
    "media-sound/picard",
    "mplayer",
    "musicbrainz",
  ]

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

  package { $packages: ensure => installed }

  package {
    $gentoo_studio_packages: ensure => installed,
    require                         => Layman['pro-audio'],
  }

  layman { 'pro-audio':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
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

  service { 'jackd':
    ensure => running,
    enable => true,
    require   => [
      File['/etc/conf.d/jackd'],
      Package[jackd-init],
    ],
  }

}
