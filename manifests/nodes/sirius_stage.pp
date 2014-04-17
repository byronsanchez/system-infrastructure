node 'sirius.internal.nitelite.io' inherits network {

  $iptables_type="web"
  # Locale
  $linguas="en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru"

  class { "base":
    hostname          => "sirius",
    network_interface => "eth0",
  }
  class { "gentoo": }
  class { "security":
    iptables_type => "web",
  }

  # Add node-specific resources
  class { "ldap": }
  class { "rsyncd": }
  class { "webserver": }
  class { "nitelite":
    environment => "stage",
  }

  # VPN server must be identified uniquely per node because it is the only
  # service that needs true direct access to the host server. All other services
  # defined in the local subnet (even hosts for remote nodes) will be accessed
  # through this VPN tunnel.
  class { "vpnclient":
    vpn_server => "10.66.77.100",
  }

  # users
  # TODO: migrate to LDAP
  class { "root": }
  class { "deployer": }
  class { "byronsanchez":
    groups => ['audio', 'cdrom', 'usb', 'wheel',],
  }

}