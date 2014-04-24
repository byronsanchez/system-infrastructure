node 'sirius.external.nitelite.io' inherits network {

  $iptables_type="web"
  # Locale
  $linguas="en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru"

  # ldap
  $ldap_type="client"

  class { "base":
    hostname          => "sirius",
    network_interface => "eth0",
  }
  class { "gentoo": }
  class { "security":
    iptables_type => "web",
  }
  class { "ssh":
    username => [
      "rbackup",
      "deployer",
      "staff",
    ],
  }

  # Add node-specific resources
  class { "ldap":
    ldap_type => "${ldap_type}"
  }
  class { "rsyncd": }
  class { "webserver": }
  class { "php": }
  class { "nitelite":
    environment => "production",
  }

  # VPN server must be identified uniquely per node because it is the only
  # service that needs true direct access to the host server. All other services
  # defined in the local subnet (even hosts for remote nodes) will be accessed
  # through this VPN tunnel.
  class { "vpnclient":
    vpn_server => "nitelite.bounceme.net",
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }

}
