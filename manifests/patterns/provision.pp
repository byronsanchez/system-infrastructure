# must overlay rsyncd (for xinetd)
# must overlay nas

class provision {

  file { "/etc/xinetd.d/tftpd":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/xinetd.d/tftpd",
    source  => "puppet:///files/provision/etc/xinetd.d/tftpd",
    require => File["/etc/xinetd.d"],
  }

  file { "/srv/tftp":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/srv"],
  }

  file { "/etc/rsyncd.d/provision.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/rsyncd.d/provision.conf",
    source => "puppet:///files/provision/etc/rsyncd.d/provision.conf",
    require => File["/etc/rsyncd.d"],
  }

  # Make the provision directory available via rsync
  # Used for remotes so that they may download the autoinstall script
  file { "/srv/rsync/gentoo-provision":
     ensure  => 'link',
     target  => "/var/lib/nitelite/provision/gentoo-provision",
     require => Vcsrepo["/var/lib/nitelite/provision/gentoo-provision"],
  }

  # Kernel bins and configs are available via rsync at this location.
  # Used for updating nodes on the subnet.
  file { '/srv/rsync/gentoo-boot':
     ensure  => 'link',
     target  => "/var/lib/nitelite/provision/gentoo-provision/kernel/build",
     require => Vcsrepo["/var/lib/nitelite/provision/gentoo-provision"],
  }

  # Make the pxe directory available via tftp
  file { '/srv/tftp/boot-pxe':
     ensure  => 'link',
     target  =>
     "/var/lib/nitelite/provision/gentoo-bootmodder/profiles/internal.nitelite.io/devices/pxe",
     require => [
       File["/srv/tftp"],
       Vcsrepo["/var/lib/nitelite/provision/gentoo-bootmodder"],
     ],
  }

  file { "/usr/local/bin/provision":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/provision",
    source => "puppet:///files/provision/usr/local/bin/provision",
  }

  file { "/var/lib/nitelite/provision":
    ensure => 'directory',
    mode    => 0755,
    require => File["/var/lib/nitelite"],
  }

  vcsrepo { "/var/lib/nitelite/provision/gentoo-provision":
    ensure   => present,
    provider => git,
    source   => "https://git.nitelite.io/hackbytes/gentoo-provision",
    require => File["/var/lib/nitelite/provision"],
  }

  vcsrepo { "/var/lib/nitelite/provision/gentoo-bootmodder":
    ensure   => present,
    provider => git,
    source   => "https://git.nitelite.io/hackbytes/gentoo-bootmodder",
    require => File["/var/lib/nitelite/provision"],
  }

  $packages = [
    "app-cdr/cdrtools",
    "sys-boot/syslinux",
    "sys-fs/squashfs-tools",
    "tftp-hpa",
  ]

  package { $packages:
    ensure  => installed,
  }

}
