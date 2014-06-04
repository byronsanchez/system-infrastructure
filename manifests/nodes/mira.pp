node 'mira.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "mira",
    network_interface => "eth0",
  }

  class { "gentoo":
    use_flags     => "mysql",
    linguas       => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    video_cards   => "",
    input_devices => "evdev",
    lowmemorybox  => false,
  }

  class { "security":
    iptables_type => "workstation",
  }

  class { "ssh":
    username => [
      "root",
      "rbackup",
      "staff",
      "byronsanchez",
    ],
  }

  class { "backup": }

  class { "vcs": }

  class { "nasclient": }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type => "client",
  }

  class { "rsyncd": }

  class { "webserver": }

  class { "vpn":
    vpn_type => "client",
  }

  class { "xorgserver": }

  class { "media": }

  class { "workstation": }

  class { "nodejs": }

  class { "php": }

  class { "java": }

  class { "ruby": }

  class { "nl_rvm":
    user => "byronsanchez",
    home => "/home/byronsanchez",
  }

  class { "nl_nvm":
    user => "byronsanchez",
    home => "/home/byronsanchez",
  }

  class { "mobile": }

  # users
  class { "root": }
  class { "rbackup": }
  class { "deployer": }
  class { "staff": }
  class { "byronsanchez":
    #groups    => ['plugdev', 'android'],
    groups => ['audio', 'cdrom', 'kvm', 'usb', 'wheel',],
  }
  class { "logger": }



}
