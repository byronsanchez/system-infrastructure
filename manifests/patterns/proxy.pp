class proxy {

  file { "/etc/squid/squid.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/squid/squid.conf",
    source => "puppet:///files/proxy/etc/squid/squid.conf",
  }

  $packages = [
    "squid",
    "privoxy",
  ]

  package { $packages: ensure => installed }

  service { 'squid':
    ensure => running,
    enable => true,
    subscribe => File['/etc/squid/squid.conf'],
    require   => [
      File['/etc/squid/squid.conf'],
      Package[squid],
    ],
  }

}
