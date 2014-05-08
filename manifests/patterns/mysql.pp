class mysql($db_type) {

  file { "/etc/portage/package.use/mariadb":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/mariadb",
    content => template("mysql/etc/portage/package.use/mariadb.erb"),
  }

  file { "/etc/mysql/my.cnf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/mysql/my.cnf",
    content => template("mysql/etc/mysql/my.cnf.erb"),
  }

  file { "/etc/mysql/mysqlaccess.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/mysql/mysqlaccess.conf",
    source  => "puppet:///files/mysql/etc/mysql/mysqlaccess.conf",
  }

  $packages = [
    "mariadb",
  ]

  # Make sure mysql is uninstalled
  package { mysql:
    ensure => absent,
  }

  package { mariadb:
    ensure  => installed,
    require => Package[mysql],
  }

  service { 'mysql':
    ensure  => running,
    enable  => true,
    subscribe => File['/etc/mysql/my.cnf'],
    require => [
      Package[mariadb],
      File['/etc/mysql/my.cnf']
    ],
  }

  # Only run once after the initial installation
  # runs configuration with defaults from conf.d/postgresql-9.3
  # TODO: Auto answer yes to the emerge question
  exec { "mariadb_config":
    command => "/usr/bin/emerge --config -y mariadb",
    refreshonly => true,
    require => [
      Package[mariadb],
    ],
  }

}