node 'sirius-production-1.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "sirius-production-1",
    # TODO: make sure all nodes use eth[n] interface names for consistency
    # across all nodes
    network_interface => "enp0s3",
  }

  class { "gentoo":
    use_flags       => "mysql",
    linguas         => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox    => false,
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

  class { "vcs": }

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
