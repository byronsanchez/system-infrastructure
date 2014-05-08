class java {

  file { "/etc/portage/package.use/java":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/java",
    source => "puppet:///files/java/etc/portage/package.use/java",
  }

  $packages = [
    "icedtea-bin",
  ]

  package { $packages: ensure => installed }

}
