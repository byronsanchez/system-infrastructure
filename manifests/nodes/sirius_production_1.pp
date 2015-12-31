node 'sirius-production-1.internal.nitelite.io' inherits network {

  $environment = "production"

  class { "base":
    environment       => "${environment}",
    hostname          => "sirius-${environment}-1",
    # TODO: make sure all nodes use eth[n] interface names for consistency
    # across all nodes
    network_interface => "eth0",
    enable_docker     => true,
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
    environment  => "${environment}",
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

  class { "backup": }

  class { "vcs":
    vcs_type           => "mirror",
    mirror_environment => "${environment}",
  }

  class { "data":
    data_type => "client",
  }

  class { "mysql": 
    db_type => "client",
  }

  class { "mail":
    mail_type => "standalone",
  }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type => "client",
  }

  class { "rsyncd": }

  class { "webserver": }

  class { "php":
    environment => "${environment}",
    php_timezone => 'America/New_York',
  }

  class { "nodejs": }

  class { "nitelite":
    environment => "${environment}",
  }

}
