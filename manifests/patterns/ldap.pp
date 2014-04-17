class ldap {

  $rootpw = hiera('rootpw')

  # TODO: sudoers in ldap to remind myself to migrate to ldap!
  file { "/etc/sudoers":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '440',
    path => "/etc/sudoers",
    source => "puppet:///files/ldap/etc/sudoers",
  }

  file { "/etc/sudoers.d":
    ensure => "directory",
    owner => "root",
    group => "root",
    mode   => '750',
  }

  file { "/etc/sudoers.d/byronsanchez":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '440',
    require => File['/etc/sudoers.d'],
    path => "/etc/sudoers.d/byronsanchez",
    source => "puppet:///files/ldap/etc/sudoers.d/byronsanchez",
  }

  file { "/etc/sudoers.d/rbackup":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '440',
    require => File['/etc/sudoers.d'],
    path => "/etc/sudoers.d/rbackup",
    source => "puppet:///files/ldap/etc/sudoers.d/rbackup",
  }

  file { "/etc/portage/package.use/openldap":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/openldap",
    source => "puppet:///files/ldap/etc/portage/package.use/openldap",
  }

  file { "/etc/openldap":
    ensure => "directory",
    owner => "root",
    group => "root",
    mode   => '755',
  }

  file { "/etc/conf.d/slapd":
    ensure => present,
    mode => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/ldap/etc/conf.d/slapd",
  }

  file { "/etc/openldap/slapd.conf":
    ensure => present,
    owner => "root",
    group => "ldap",
    mode    => '640',
    require => File['/etc/openldap'],
    path => "/etc/openldap/slapd.conf",
    content => template("ldap/etc/openldap/slapd.conf.erb"),
  }

  file { "/etc/openldap/ldap.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    require => File['/etc/openldap'],
    path => "/etc/openldap/ldap.conf",
    source => "puppet:///files/ldap/etc/openldap/ldap.conf",
  }

  file { "/var/lib/openldap-ldbm":
    ensure  => "directory",
    owner   => "ldap",
    group   => "ldap",
    mode    => '700',
    recurse => true,
  }

  file { "/var/lib/openldap-ldbm/DB_CONFIG":
    ensure => present,
    owner => "ldap",
    group => "ldap",
    mode    => '644',
    require => File['/var/lib/openldap-ldbm'],
    path => "/var/lib/openldap-ldbm/DB_CONFIG",
    source => "puppet:///files/ldap/var/lib/openldap-ldbm/DB_CONFIG",
  }

  $packages = [
    "openldap",
    "pam_ldap",
    "nss_ldap",
  ]

  package { $packages: ensure => 'installed' }

  service { 'slapd':
    ensure  => 'running',
    enable  => 'true',
    subscribe => File['/etc/openldap/slapd.conf'],
    require => [
      Package[openldap],
      File['/etc/openldap/slapd.conf']
    ],
  }

}
