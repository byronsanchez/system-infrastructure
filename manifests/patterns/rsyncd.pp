# base configuration for rsync daemon
#
# binhost and provision can overlay this

class rsyncd {

  file { "/etc/xinetd.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/xinetd.conf",
    source => "puppet:///files/rsyncd/etc/xinetd.conf",
  }

  file { "/etc/xinetd.d":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/xinetd.d/rsyncd":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/xinetd.d/rsyncd",
    source  => "puppet:///files/rsyncd/etc/xinetd.d/rsyncd",
    require => File["/etc/xinetd.d"],
  }

  file { "/etc/rsyncd.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/rsyncd.conf",
    source => "puppet:///files/rsyncd/etc/rsyncd.conf",
  }

  file { "/etc/rsyncd.d":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/srv/rsync":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/srv"],
  }

  $packages = [
    "xinetd",
  ]

  package { $packages:
    ensure  => installed,
  }

  service { 'xinetd':
    ensure => running,
    enable => true,
    subscribe => File['/etc/xinetd.conf'],
    require   => [
      File['/etc/xinetd.conf'],
      Package[xinetd],
    ],
  }

  # disable rsync daemon via standard distro service. xinetd will handle this.
  service { 'rsyncd':
    ensure => stopped,
    enable => false,
  }

}
