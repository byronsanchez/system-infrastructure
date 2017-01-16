# can be overridden by:
# puppet

# nas_type
#   - server - nfs and samba servers will be configured
#   - workstation - workstation nfs and samba server will be configured
#   - client - only client configuration will be performed

class nas (
  $nas_type,
) {

  if ($nas_type == "server") or ($nas_type == "workstation") {

    class { "nl_nfs": }

    file { "/etc/hosts.allow":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      path => "/etc/hosts.allow",
      source => "puppet:///files/nas/etc/hosts.allow",
    }

    file { "/etc/hosts.deny":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      path => "/etc/hosts.deny",
      source => "puppet:///files/nas/etc/hosts.deny",
    }

    file { "/etc/samba":
      ensure => "directory",
      owner => "root",
      group => "root",
      mode   => '755',
    }

    file { "/etc/samba/lmhosts":
      ensure => present,
      owner => "root",
      group => "root",
      mode    => '644',
      require => File['/etc/samba'],
      path => "/etc/samba/lmhosts",
      source => "puppet:///files/nas/etc/samba/lmhosts",
    }

    file { "/etc/samba/smb.conf":
      ensure => present,
      owner => "root",
      group => "root",
      mode    => '644',
      require => File['/etc/samba'],
      path => "/etc/samba/smb.conf",
      content => template("nas/etc/samba/smb.conf.erb"),
    }

    file { "/etc/samba/smbusers":
      ensure => present,
      owner => "root",
      group => "root",
      mode    => '644',
      require => File['/etc/samba'],
      path => "/etc/samba/smbusers",
      source => "puppet:///files/nas/etc/samba/smbusers",
    }

    $packages = [
      "samba",
    ]

    package { $packages: ensure => installed }

    # TODO: ensure all files listed in exports are created
    service { 'samba':
      ensure  => 'running',
      enable  => 'true',
      subscribe => File['/etc/samba/smb.conf'],
      require => [
        Package[samba],
        File['/etc/samba/smb.conf']
      ],
    }

  }


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

