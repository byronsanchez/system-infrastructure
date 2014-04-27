node 'polaris.internal.nitelite.io' inherits network {

  $iptables_type="dns"
  # Locale
  $linguas="en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru"

  $ldap_type="client"
  $mail_type="client"
  $dns_type="master"

  class { "base":
    hostname          => "polaris",
    network_interface => "eth0",
  }
  class { "gentoo":
    lowmemorybox => true,
  }
  class { "security":
    iptables_type => "${iptables_type}",
  }
  class { "ssh":
    username => [
      "rbackup",
      "staff",
    ],
  }
  class { "mail":
    mail_type => "${mail_type}",
  }

  # Add node-specific resources
  class { "nasclient": }
  class { "ldap":
    ldap_type => "${ldap_type}"
  }
  class { "dns":
    dns_type => "${dns_type}",
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "staff": }
  class { "logger": }

}
