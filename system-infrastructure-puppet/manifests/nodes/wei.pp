node 'wei.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "wei",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags    => "postgres",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "nas",
  }

  class { "ssh":
    username => [
      "rbackup",
      "staff",
      "deployer",
      "root",
      # this is an ldap user. placing it on the nfs server with the nfs homedir 
      # means all node access!
      "byronsanchez",
    ],
  }

  class { "backup": }

  class { "data":
    data_type => "client",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "nas":
    nas_type   => "server",
  }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type => "client",
  }

  class { "rsyncd": }

  class { "vcs": }

}
