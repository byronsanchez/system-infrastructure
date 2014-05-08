node 'kuma.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "kuma",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "mail",
  }

  class { "ssh":
    username => [
      "rbackup",
      "staff",
    ],
  }

  class { "data":
    data_type => "client",
  }

  class { "php":
    php_timezone => 'America/New_York',
  }

  class { "webserver": }

  class { "mysql": 
    db_type => "client",
  }

  class { "mail":
    mail_type => "server",
  }

  class { "nasclient": }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type => "mail",
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }
  class { "logger": }

}
