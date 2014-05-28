node 'chow.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "chow",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "postgres",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "vcs",
  }

  class { "ssh":
    username => [
      "rbackup",
      "staff",
      "root",
    ],
  }

  class { "data":
    data_type => "client",
  }

  class { "mysql": 
    db_type => "client",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "nasclient": }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type => "client",
  }

  class { "java":
    java_type => "server",
  }

  class { "rsyncd": }

  class { "webserver": }

  class { "vcs":
    vcs_type => "server",
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }
  class { "logger": }

}
