class dns($dns_type) {

  file { "/etc/bind/named.conf":
    ensure => present,
    path => "/etc/bind/named.conf",
    owner => "root",
    group => "root",
    content => template("dns/etc/bind/named.conf.erb"),
  }

  if $dns_type == "master" {

    file { "/var/bind/pri/hackbytes.com.internal":
      ensure => present,
      path => "/var/bind/pri/hackbytes.com.internal",
      source => "puppet:///files/dns/var/bind/pri/hackbytes.com.internal",
    }

    file { "/var/bind/pri/nitelite.io.internal":
      ensure => present,
      path => "/var/bind/pri/nitelite.io.internal",
      source => "puppet:///files/dns/var/bind/pri/nitelite.io.internal",
    }

    file { "/var/bind/pri/chompix.com.internal":
      ensure => present,
      path => "/var/bind/pri/chompix.com.internal",
      source => "puppet:///files/dns/var/bind/pri/chompix.com.internal",
    }

    file { "/var/bind/pri/tehpotatoking.com.internal":
      ensure => present,
      path => "/var/bind/pri/tehpotatoking.com.internal",
      source => "puppet:///files/dns/var/bind/pri/tehpotatoking.com.internal",
    }

    file { "/var/bind/pri/byronsanchez.net.internal":
      ensure => present,
      path => "/var/bind/pri/byronsanchez.net.internal",
      source => "puppet:///files/dns/var/bind/pri/byronsanchez.net.internal",
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
