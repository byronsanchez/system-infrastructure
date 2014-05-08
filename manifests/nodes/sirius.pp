node 'sirius.external.nitelite.io' inherits network {

  class { "base":
    hostname          => "sirius",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

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

  class { "mysql": 
    db_type => "client",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "ldap":
    ldap_type => "client"
  }

  class { "rsyncd": }

  class { "webserver": }

  class { "php": }

  class { "nodejs": }

  class { "nitelite":
    environment => "production",
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }
  class { "logger": }

}
