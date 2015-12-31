# ldap server must overlay webserver

class ldap($ldap_type) {

  $rootpw = hiera('rootpw', '')
  $ldapreaderpw = hiera('ldapreaderpw', '')

  # TODO: Determine if it makes sense to have sudo read from ldap

  file { "/etc/portage/package.use/openldap":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/openldap",
    source => "puppet:///files/ldap/etc/portage/package.use/openldap",
  }

  file { "/etc/nsswitch.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/nsswitch.conf",
    source => "puppet:///files/ldap/etc/nsswitch.conf",
  }

  file { "/etc/openldap":
    ensure  => "directory",
    owner   => "ldap",
    group   => "ldap",
    recurse => "true",
    mode    => '755',
  }

  file { "/etc/ldap.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/ldap.conf",
    source => "puppet:///files/ldap/etc/ldap.conf",
  }

  if $ldap_type == "master" {

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

  $packages_require = [
    File["/etc/portage/package.use/openldap"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  # Only run slapd on the master ldap server
  if $ldap_type == "master" {

    service { 'slapd':
      ensure  => 'running',
      enable  => 'true',
      subscribe => File['/etc/openldap/slapd.conf'],
      require => [
        Package[openldap],
        File['/etc/openldap/slapd.conf']
      ],
    }

  } else {

    service { 'slapd':
      ensure  => 'stopped',
      enable  => 'false',
      require => [
        Package[openldap],
      ],
    }
  }

  file { "/usr/local/share/ca-certificates/nitelite.io/ldap.crt":
    ensure  => present,
    owner   => "ldap",
    group   => "ldap",
    require => File['/usr/local/share/ca-certificates/nitelite.io'],
    path    => "/usr/local/share/ca-certificates/nitelite.io/ldap.crt",
    source  => "puppet:///secure/ssl/ldap/cacert.pem",
  }

  exec { "certificates_update_ldap":
    command => "/usr/sbin/update-ca-certificates",
    subscribe   => File['/etc/ca-certificates.conf'],
    require => [
      Package['ca-certificates'],
      File['/etc/ca-certificates.conf'],
      File['/usr/local/share/ca-certificates/nitelite.io/ldap.crt'],
    ],
  }

}
