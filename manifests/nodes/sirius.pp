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

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }

}
