# can be overridden by:
# puppet

class nas {

  file { "/srv/nfs":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    mode    => '755',
    require => File["/srv"],
  }

  file { "/etc/exports":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    path => "/etc/exports",
    source => "puppet:///files/nas/etc/exports",
  }

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
    source => "puppet:///files/nas/etc/samba/smb.conf",
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
    "nfs-utils",
    "samba",
  ]

  package { $packages: ensure => installed }

  service { 'nfs':
    ensure  => 'running',
    enable  => 'true',
    subscribe => File['/etc/exports'],
    require => [
      Package[nfs-utils],
      File['/etc/exports'],
    ],
  }

  service { 'samba':
    ensure  => 'running',
    enable  => 'true',
    subscribe => File['/etc/samba/smb.conf'],
    require => [
      Package[samba],
      File['/etc/samba/smb.conf']
    ],
  }

  exec { "nfs_export":
    command => "/usr/sbin/exportfs -a",
    subscribe   => File['/etc/exports'],
    refreshonly => true,
  }

}
