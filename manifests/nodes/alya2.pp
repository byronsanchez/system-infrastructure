node 'alya2.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "alya2",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "postgres",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "pgsql",
  }

  class { "ssh":
    username => [
      "rbackup",
      "staff",
    ],
  }

  class { "backup": }

  class { "vcs": }

  class { "data":
    data_type => "client",
  }

  class { "mysql": 
    db_type => "client",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "nas":
    nas_type => "client",
  }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type  => "pg",
    ca_owner => "postgres",
    ca_group => "postgres",
  }

  class { "pgsql":
    db_type          => "slave",
    pgmaster_address => "${pgmaster_address}",
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }
  class { "logger": }

}
