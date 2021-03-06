node 'navi.internal.nitelite.io' inherits network {

  class { "base":
    hostname          => "navi",
    network_interface => "eth0",
    mcollective_type  => "client",
  }

  class { "gentoo":
    use_flags    => "postgres",
    linguas      => "en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru",
    lowmemorybox => false,
  }

  class { "security":
    iptables_type => "binhost",
  }

  class { "ssh":
    username => [
      "rbackup",
      "staff",
      "deployer",
      "jenkins",
    ],
  }

  class { "backup": }

  class { "data":
    data_type => "client",
  }

  class { "mail":
    mail_type => "client",
  }

  class { "pki":
    ca_type => "server",
  }

  class { "binhost":
    portage_package_directory => "/srv/nfs/io/gentoo-local-packages",
    portage_directory         => "/srv/nfs/io/gentoo-local-portage",
    portage_tree_directory    => "/srv/nfs/io/gentoo-portage",
    gentoo_directory          => "/srv/nfs/io/gentoo",
    application_directory     => "/srv/nfs/io/overlay-nitelite-applications",
    overlay_a                 => "/srv/nfs/io/overlay-nitelite-a",
    overlay_b                 => "/srv/nfs/io/overlay-nitelite-b",
    external_directory        => "/srv/nfs/io/external",
    boxes_directory           => "/srv/nfs/io/boxes",
  }

  class { "rsyncd": }
  class { "provision": }

  class { "nodejs": }

  class { "ruby": }

  class { "nl_rvm":
    user => "jenkins",
    home => "/var/lib/jenkins",
  }

  class { "nl_nvm":
    user => "jenkins",
    home => "/var/lib/jenkins",
  }

  class { "java":
    java_type => "server",
  }

  class { "rsyncd": }

  class { "webserver": }

  class { "vcs":
    vcs_type => "server",
  }

  class { "ci": }

}
