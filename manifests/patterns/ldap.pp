# ldap server must overlay webserver

class ldap($ldap_type) {

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

  file { "/etc/sudoers.d/staff":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '440',
    require => File['/etc/sudoers.d'],
    path => "/etc/sudoers.d/staff",
    source => "puppet:///files/ldap/etc/sudoers.d/staff",
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

    file { "/etc/portage/package.use/phpldapadmin":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/phpldapadmin",
      source => "puppet:///files/ldap/etc/portage/package.use/phpldapadmin",
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

    file { "/etc/vhosts/webapp-config":
      ensure => present,
      owner => "root",
      group => "root",
      mode    => '644',
      path => "/etc/vhosts/webapp-config",
      source => "puppet:///files/ldap/etc/vhosts/webapp-config",
    }

    nl_nginx::website { "phpldapadmin":
      websiteName     => "ldap.internal.nitelite.io",
      environmentName => "production",
      feed_path       => "ldap",
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

  file { "/etc/pam.d/system-auth":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/pam.d/system-auth",
    source => "puppet:///files/ldap/etc/pam.d/system-auth",
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

  file { "/etc/cron.daily/backup_ldap":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/etc/cron.daily/backup_ldap",
    source => "puppet:///files/ldap/etc/cron.daily/backup_ldap",
    require => File["/etc/cron.daily"],
  }

  $packages = [
    "openldap",
    "pam_ldap",
    "nss_ldap",
  ]

  package { $packages: ensure => 'installed' }

  # Only run slapd on the master ldap server
  if $ldap_type == "master" {

    eselect { 'php::fpm':
      set => 'php5.4',
    }

    package { "phpldapadmin":
      ensure  => 'installed',
      require => Package[nginx],
    }

    service { 'slapd':
      ensure  => 'running',
      enable  => 'true',
      subscribe => File['/etc/openldap/slapd.conf'],
      require => [
        Package[openldap],
        File['/etc/openldap/slapd.conf']
      ],
    }

    exec { "webapp_config_ldap":
      command => "/usr/sbin/webapp-config -I -h ldap.${internal_domain} -d phpldapadmin phpldapadmin 1.2.3",
      creates => "/srv/www/ldap.${internal_domain}/htdocs/phpldapadmin",
      require => [
        Package[phpldapadmin],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
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

}
