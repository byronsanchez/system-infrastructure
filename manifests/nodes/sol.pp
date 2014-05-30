node 'sol.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "sol",
    network_interface => "enp3s0",
    network_type      => "hypervisor",
    mcollective_type  => "client",
  }

  class { "gentoo":
    use_flags     => "mysql",
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
      "byronsanchez",
    ],
  }

  class { "vcs": }

  class { "data":
    data_type => "client",
  }

  class { "mysql": 
    db_type => "client",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "nas": }

  class { "nasclient": }

  class { "ldap":
    ldap_type => "client"
  }

  class { "pki":
    ca_type => "puppet",
  }

  class { "backup": }

  class { "rsyncd": }

  class { "webserver": }

  class { "binhost":
    portage_package_directory => "/srv/nfs/io/gentoo-local-packages",
    portage_tree_directory    => "/srv/nfs/io/gentoo-portage",
    gentoo_directory          => "/srv/nfs/io/gentoo",
    application_directory     => "/srv/nfs/io/overlay-nitelite-applications",
    overlay_a                 => "/srv/nfs/io/overlay-nitelite-a",
    overlay_b                 => "/srv/nfs/io/overlay-nitelite-b",
    external_directory        => "/srv/nfs/io/external",
  }

  class { "provision":
    boot_pxe_path    => "/srv/nfs/luna/Projects/hackbytes/gentoo-bootmodder/profiles/internal.nitelite.io/devices/pxe",
    boot_update_path => "/srv/nfs/luna/Projects/hackbytes/gentoo-provision/kernel",
    # Used for remotes so that they may download the autoinstall script
    rsync_provision_directory => "/srv/nfs/luna/Projects/hackbytes/gentoo-provision",
  }

  class { "hypervisor": }

  class { "xorgserver": }

  class { "mirror": }

  class { "media": }

  class { "nodejs": }

  class { "php": }

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
