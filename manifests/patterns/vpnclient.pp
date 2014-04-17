class vpnclient ($vpn_server) {

  file { "/etc/openvpn/openvpn.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/openvpn/openvpn.conf",
    content => template("vpnclient/etc/openvpn/openvpn.conf.erb"),
  }

  $packages = [
    "openvpn",
  ]

  package { $packages: ensure => installed }

}
