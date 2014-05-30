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
