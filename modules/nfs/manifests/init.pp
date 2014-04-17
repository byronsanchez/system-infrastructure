class nfs {

  $exports = hiera('exports')

  file { "/srv/nfs":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    mode    => '755',
    require => File["/srv"],
  }

  file { "/etc/exports":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    path => "/etc/exports",
    content => template('nfs/etc/exports.erb'),
  }

  file { "${exports}":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/srv/nfs"],
  }

  $packages = [
    "nfs-utils",
  ]

  package { $packages: ensure => installed }

  # TODO: ensure all files listed in exports are created
  service { 'nfs':
    ensure  => 'running',
    enable  => 'true',
    subscribe => File['/etc/exports'],
    require => [
      Package[nfs-utils],
      File['/etc/exports'],
    ],
  }

  exec { "nfs_export":
    command => "/usr/sbin/exportfs -a",
    subscribe   => File['/etc/exports'],
    refreshonly => true,
  }
}
