node 'sol.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "sol",
    network_interface => "enp3s0",
    network_type      => "hypervisor",
    mcollective_type  => "client",
  }

  class { "gentoo":
    use_flags     => "postgres",
    linguas       => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    video_cards   => "radeon",
    input_devices => "evdev",
    lowmemorybox  => false,
  }

  class { "security":
    iptables_type => "hypervisor",
  }

  class { "ssh":
    username => [
      "root",
      "rbackup",
      "staff",
      "deployer",
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
    ca_type => "client",
  }

  class { "rsyncd": }

  class { "hypervisor": }

}
