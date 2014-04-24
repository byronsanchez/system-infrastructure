# can be overridden by:
# puppet

class nas {

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
