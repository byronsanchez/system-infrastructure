node 'sirius-development-1.internal.nitelite.io' inherits network {

  $environment = "development"

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

  class { "mail":
    mail_type => "standalone",
  }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type => "client",
  }

  class { "deploy": }

  # currently not containerizing the db portion, so this is still outside of
  # scope of docker
  class { "mysql": 
    db_type => "client",
  }

  class { "webserver": }

  # from this point on, we have moved on from the host patterns to application
  # level patterns

  #class { "php":
  #  environment => "{environment}",
  #  php_timezone => 'America/New_York',
  #}

  #class { "nodejs": }

  #class { "nitelite":
  #  environment => "${environment}",
  #}

}
