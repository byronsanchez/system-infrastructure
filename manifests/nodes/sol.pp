node 'sol.internal.nitelite.io' inherits network {
  # TODO: Find a way to add "custom host definitions" from within node scope
  # TODO: Maybe convert these to params so it becomes more intuitive that they
  # belong to one of the classes below.

  # TODO: Consider implementation of IPv6

  $video_cards = "radeon"
  $input_devices = "evdev"
  # The iptables file to load (TODO: research use of augeas)
  $iptables_type="hypervisor"
  # used by mysysconf template to determine how to setup network interface for
  # the node
  $network_type="hypervisor"
  # Locale
  $linguas="en_US en en_GB es zh_CN zh_TW zh_HK ja jp fr_FR fr fr_CA ru_RU ru"

  # provision

  $boot_pxe_path = "/vol/luna/Projects/hackbytes/gentoo-provision/profiles/internal.nitelite.io/devices/pxe"
  # Used by puppet pattern to build link to puppet path for nfs share
  $puppet_path="/vol/luna/Projects/hackbytes/puppet"
  # Used for remotes so that they may download the autoinstall script
  $rsync_provision_directory="/vol/luna/Projects/hackbytes/gentoo-provision"

  # binhost

  $portage_package_directory = "/vol/io/gentoo-local-packages"
  $portage_tree_directory = "/vol/io/gentoo-portage"
  # TODO: Change to full mirror once it's available
  $gentoo_directory = "/vol/io/gentoo-stages"

  # Setup host configuration
  class { "base":
    hostname          => "sol",
    network_interface => "enp3s0",
  }
  class { "gentoo": }
  class { "security":
    iptables_type => "hypervisor",
  }

  # Add node-specific resources
  class { "ldap": }
  class { "vcs": }
  class { "backup": }
  class { "rsyncd": }
  class { "webserver": }
  class { "binhost": }
  class { "nas": }
  class { "vpnserver": }
  class { "provision": }
  class { "hypervisor": }
  class { "xorgserver": }
  class { "mail": }
  class { "mirror": }
  class { "media": }
  class { "workstation": }

  # users
  # TODO: migrate to LDAP
  class { "root": }
  class { "byronsanchez":
    #groups    => ['wheel', 'audio', 'cdrom', 'usb', 'plugdev', 'android'],
    groups => ['audio', 'cdrom', 'kvm', 'usb', 'wheel',],
  }

}
