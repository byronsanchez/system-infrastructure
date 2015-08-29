node 'maia.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "maia",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "data",
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
    data_type => "server",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "pki":
    ca_type => "data",
  }

  class { "amqp": }

  # users
  class { "root": }
  class { "rbackup": }
  class { "staff": }
  class { "logger": }

}

