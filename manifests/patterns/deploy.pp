class deploy(
  $deploy_type,
) {

  if $deploy_type == "host" {
  }

  if $deploy_type == "client" {
  }

  file { "/etc/portage/package.accept_keywords/overlay-docker":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/overlay-",
    source => "puppet:///files/deploy/etc/portage/package.accept_keywords/overlay-docker",
  }

  layman { 'docker':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
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

  $pip_packages = [
    "docker-registry",
  ]

  package { $pip_packages:
    ensure  => installed,
    provider => 'pip',
    require => [
      Eselect[python],
    ],
  }

}
