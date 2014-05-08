# must overlay rsyncd (for xinetd)
# must overlay nas

class provision (
  $boot_pxe_path = '',
  $boot_update_path = '',
  $puppet_path = '',
  $rsync_provision_directory = '',
){

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

  file { "/etc/rsyncd.d/provision.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/rsyncd.d/provision.conf",
    source => "puppet:///files/provision/etc/rsyncd.d/provision.conf",
    require => File["/etc/rsyncd.d"],
  }

  if $boot_pxe_path {

    file { '/srv/tftp/boot-pxe':
       ensure  => 'link',
       target  => "${boot_pxe_path}",
       require => File["/srv/tftp"],
    }

  }

  # Make the provision directory available via rsync
  if $rsync_provision_directory {
    file { "/srv/rsync/gentoo-provision":
       ensure  => 'link',
       target  => "${rsync_provision_directory}",
       require => File["/srv/rsync"],
    }
  }

  if $boot_update_path {

    file { '/srv/rsync/gentoo-boot':
       ensure  => 'link',
       target  => "${boot_update_path}",
       require => File["/srv/rsync"],
    }

  }

  file { "/usr/local/bin/provision":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/provision",
    source => "puppet:///files/provision/usr/local/bin/provision",
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
