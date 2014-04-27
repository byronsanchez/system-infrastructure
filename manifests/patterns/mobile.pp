# TODO: add icedtea bin or abstract it out of workstation.pp
class mobile {

  file { "/etc/profile.d/mobile.custom.sh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/profile.d'],
    path => "/etc/profile.d/mobile.custom.sh",
    source => "puppet:///files/mobile/etc/profile.d/mobile.custom.sh",
  }

  file { "/etc/profile.d/path.custom.sh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/profile.d'],
    path => "/etc/profile.d/path.custom.sh",
    source => "puppet:///files/base/etc/profile.d/path.custom.sh",
  }

  $packages = [
    "android-sdk-update-manager",
    "ant",
    "maven-bin",
  ]

  package { $packages: ensure => 'installed' }

}
