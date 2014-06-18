class deploy {

  file { "/etc/portage/package.unmask/docker":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.unmask'],
    path => "/etc/portage/package.use/docker",
    source => "puppet:///files/deploy/etc/portage/package.use/docker",
  }

  $packages = [
    "app-emulation/docker",
  ]

  package { $packages: ensure => installed }

  service { 'docker':
    ensure => running,
    enable => true,
    require   => [
      Package['app-emulation/docker'],
    ],
  }
}
