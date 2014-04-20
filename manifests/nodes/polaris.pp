node 'polaris.internal.nitelite.io' inherits network {

  $iptables_type="dns"
  # Locale
  $linguas="en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru"

  # DNS server settings
  $dns_type="master"

  class { "base":
    hostname          => "polaris",
    network_interface => "eth0",
  }
  class { "gentoo": }
  class { "security":
    iptables_type => "${iptables_type}",
  }

  # Add node-specific resources
  class { "ldap": }
  class { "dns":
    dns_type => "${dns_type}",
  }

  # users
  # TODO: migrate to LDAP
  class { "root": }
  class { "rbackup": }
  class { "byronsanchez":
    groups => ['audio', 'cdrom', 'usb', 'wheel',],
  }

}
