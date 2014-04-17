# must overlay rsyncd
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

  if $puppet_path {

    file { "/srv/nfs/puppet":
      ensure  => "directory",
      owner   => "root",
      group   => "root",
      require => File["/srv/nfs"],
    }

    # Need to bind mount as symlinks will not work with nfs
    mount { "/srv/nfs/puppet":
      ensure  => mounted,
      device  => "${puppet_path}",
      fstype  => "none",
      options => "rw,bind",
      require => File["/srv/nfs/puppet"],
    }
  }

  file { "/srv/tftp":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/srv"],
  }

  if $boot_pxe_path {

    file { '/srv/tftp/boot-pxe':
       ensure  => 'link',
       target  => "${boot_pxe_path}",
       require => File["/srv/tftp"],
    }

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
