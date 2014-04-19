class dns($dns_type) {

  file { "/etc/bind/named.conf":
    ensure => present,
    path => "/etc/bind/named.conf",
    owner => "root",
    group => "root",
    content => template("dns/etc/bind/named.conf.erb"),
  }

  if $dns_type == "master" {

    file { "/var/bind/pri/internal.nitelite.io.internal":
      ensure => present,
      path => "/var/bind/pri/internal.nitelite.io.internal",
      source => "puppet:///files/dns/var/bind/pri/internal.nitelite.io.internal",
    }

    file { "/var/bind/pri/10.66.77.internal":
      ensure => present,
      path => "/var/bind/pri/10.66.77.internal",
      source => "puppet:///files/dns/var/bind/pri/10.66.77.internal",
    }

  }

  file { "/var/log/named":
    ensure => "directory",
    owner  => "named",
    group  => "named",
    mode   => 0770,
  }

  file { "/var/log/named/named.log":
    ensure => present,
    path => "/var/log/named/named.log",
    owner => "named",
    group => "named",
    mode   => 0660,
  }

  $packages = [
    "bind",
  ]

  package { $packages: ensure => installed, }

  service { 'named':
    ensure => running,
    enable => true,
    subscribe => File['/etc/bind/named.conf'],
    require => [
      File['/etc/bind/named.conf'],
      Package[bind],
    ],
  }

}
