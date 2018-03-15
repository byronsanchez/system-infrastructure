class scala {

  file { "/etc/portage/package.accept_keywords/scala":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/scala",
    source => "puppet:///files/scala/etc/portage/package.accept_keywords/scala",
  }

  $packages = [
    "dev-lang/scala",
    "sbt-bin",
  ]

  $packages_require = [
    File["/etc/portage/package.accept_keywords/scala"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  eselect { 'scala':
    set     => 'scala-2.11.4',
    require => Layman['nitelite-a'],
  }

}

