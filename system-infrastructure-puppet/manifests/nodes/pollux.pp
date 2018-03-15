node 'pollux.internal.nitelite.io' inherits network {

  $environment = "production"

  class { "base":
    environment       => "${environment}",
    hostname          => "sirius-${environment}-1",
    # TODO: make sure all nodes use eth[n] interface names for consistency
    # across all nodes
    network_interface => "eth0",
    enable_docker     => true,
  }

  class { "gentoo":
    use_flags    => "mysql",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
    environment  => "${environment}",
  }

  class { "security":
    iptables_type => "web",
  }

  class { "ssh":
    username => [
      "rbackup",
      "deployer",
      "staff",
    ],
  }

}
