node 'headofhydrus.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "headofhydrus",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "postgres",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "backup",
  }

  class { "ssh":
    username => [
      "rbackup",
      "staff",
      "deployer",
      "root",
    ],
  }

  class { "backup":
    backup_type => "server",
  }

  class { "data":
    data_type => "client",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "pki":
    ca_type => "puppet",
  }

  class { "rsyncd": }

  class { "vcs": }

}
