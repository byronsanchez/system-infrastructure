node 'electra2.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "electra2",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "ldap",
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
    ldap_type => "slave"
  }

  class { "pki":
    ca_type  => "ldap",
    ca_owner => "ldap",
    ca_group => "ldap",
  }

}
