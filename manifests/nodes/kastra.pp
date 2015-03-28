node 'kastra.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "kastra",
    network_interface => "eth0",
    mcollective_type  => "client",
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "ci",
  }

  class { "ssh":
    username => [
      "rbackup",
      "staff",
      "jenkins",
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
    ca_type => "client",
  }

  class { "nodejs": }

  class { "ruby": }

  class { "nl_rvm":
    user => "jenkins",
    home => "/var/lib/jenkins",
  }

  class { "nl_nvm":
    user => "jenkins",
    home => "/var/lib/jenkins",
  }

  class { "java": }

  class { "ci": }

  # users
  class { "root": }
  class { "rbackup": }
  class { "staff": }
  class { "logger": }

}
