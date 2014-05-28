# TODO: find a way to require the NFS module
class nasclient {
  # MOUNTS
  # These depend on a running NAS server somewhere on the network

  # Generic file share
  file { "/mnt/luna":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  mount { "/mnt/luna":
    ensure  => present,
    device  => "nas.internal.nitelite.io:/srv/nfs/luna",
    atboot  => true,
    fstype  => "nfs4",
    options => "soft,timeo=30",
    require => File['/mnt/luna'],
  }

  # Puppet manifests

  file { "/mnt/puppet":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  mount { "/mnt/puppet":
    ensure  => present,
    device  => "nas.internal.nitelite.io:/srv/nfs/puppet",
    atboot  => true,
    fstype  => "nfs4",
    options => "soft,timeo=30,ro",
    require => File['/mnt/puppet'],
  }

  # Gentoo binaries

  file { "/mnt/gentoo-local-packages":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  mount { "/mnt/gentoo-local-packages":
    ensure  => present,
    device  => "nas.internal.nitelite.io:/srv/nfs/gentoo-local-packages",
    atboot  => true,
    fstype  => "nfs4",
    options => "soft,timeo=30,ro",
    require => File['/mnt/gentoo-local-packages'],
  }

  # Gentoo portage tree

  file { "/mnt/gentoo-portage":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  mount { "/mnt/gentoo-portage":
    ensure  => present,
    device  => "nas.internal.nitelite.io:/srv/nfs/gentoo-portage",
    atboot  => true,
    fstype  => "nfs4",
    options => "soft,timeo=30,ro",
    require => File['/mnt/gentoo-portage'],
  }

  # byronsanchez home directory

  file { "/mnt/byronsanchez":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  mount { "/mnt/byronsanchez":
    ensure  => present,
    device  => "nas.internal.nitelite.io:/srv/nfs/byronsanchez",
    atboot  => true,
    fstype  => "nfs4",
    options => "soft,timeo=30",
    require => File['/mnt/byronsanchez'],
  }

  # For fstab NFS mounting
  service { nfsmount:
    ensure    => running,
    enable => true,
  }

}
