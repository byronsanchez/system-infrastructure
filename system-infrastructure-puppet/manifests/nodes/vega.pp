node 'vega.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "vega",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "pki",
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

  class { "mail":
    mail_type => "client",
  }

  class { "pki":
    ca_type => "server",
  }

}
