class vpnserver {

  file { "/etc/openvpn/openvpn.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/openvpn/openvpn.conf",
    source => "puppet:///files/vpnserver/etc/openvpn/openvpn.conf",
  }

  file { "/var/log/openvpn":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/var/lib/openvpn":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  $packages = [
    "easy-rsa",
    "openvpn",
    "noip-updater",
  ]

  package { $packages: ensure => installed }

  service { 'openvpn':
    ensure => running,
    enable => true,
    subscribe => File['/etc/openvpn/openvpn.conf'],
    require   => [
      File['/etc/openvpn/openvpn.conf'],
      File['/var/log/openvpn'],
      File['/var/lib/openvpn'],
      Package[openvpn],
    ],
  }

  service { 'noip':
    ensure => running,
    enable => true,
    require   => [
      Package[noip-updater],
    ],
  }

}
