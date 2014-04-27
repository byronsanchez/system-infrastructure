node 'sirius.internal.nitelite.io' inherits network {

  $iptables_type="web"
  # Locale
  $linguas="en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru"

  $ldap_type="client"
  $mail_type="client"

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
  class { "mail":
    mail_type => "${mail_type}",
  }

  # Add node-specific resources
  class { "nasclient": }
  class { "ldap":
    ldap_type => "${ldap_type}"
  }
  class { "rsyncd": }
  class { "webserver": }
  class { "php": }
  class { "nodejs": }
  class { "nitelite":
    environment => "stage",
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }
  class { "logger": }

}
