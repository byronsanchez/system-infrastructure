node 'electra2.internal.nitelite.io' inherits network {

  $iptables_type="ldap"
  # Locale
  $linguas="en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru"

  # ldap
  $ldap_type="slave"

  class { "base":
    hostname          => "electra2",
    network_interface => "eth0",
  }
  class { "gentoo": }
  class { "security":
    iptables_type => "${iptables_type}",
  }
  class { "ssh":
    username => [
      "rbackup",
      "staff",
    ],
  }

  # Add node-specific resources
  class { "nasclient": }
  class { "ldap":
    ldap_type => "${ldap_type}"
  }

  # users
  class { "root": }
  class { "rbackup": }
  class { "staff": }

}