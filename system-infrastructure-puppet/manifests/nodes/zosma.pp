node 'zosma.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "zosma",
    network_interface => "eth0",
  }

  class { "gentoo":
    # TODO: add mysqli for all global uses with mysql
    use_flags    => "postgres",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "systems",
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

  class { "php":
    php_timezone => 'America/New_York',
    # phpldapadmin uses 5.4 specific API
    php_version  => 'php5.4',
  }

  class { "webserver": }

  class { "mail":
    mail_type => "client",
  }

  class { "pki":
    ca_type => "nitelite.io",
  }

  class { "systems":
    cgit         => true,
    fossil       => true,
    jenkins      => true,
  }

}
