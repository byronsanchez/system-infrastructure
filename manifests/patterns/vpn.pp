class vpn(
  $vpn_type,
) {

  if $vpn_type == "server" {

    file { "/etc/openvpn/dh4096.pem":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      path => "/etc/openvpn/dh4096.pem",
      source => "puppet:///secure/vpn/dh4096.pem",
    }

    file { "/etc/openvpn/ta.key":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      path => "/etc/openvpn/ta.key",
      source => "puppet:///secure/vpn/ta.key",
    }

    $server_packages = [
      "noip-updater",
      "bridge-utils",
    ]

    package { $server_packages: ensure => installed }

    service { 'noip':
      ensure => running,
      enable => true,
      require   => [
        Package[noip-updater],
      ],
    }

  }

  file { "/etc/openvpn/openvpn.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/openvpn/openvpn.conf",
    content => template("vpn/etc/openvpn/openvpn.conf.erb"),
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
    "openvpn",
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

}
