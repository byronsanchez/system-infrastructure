# server for master server, $slave for replication, clients for local installs
# if mysql is needed as a dependency for another program (eg. php or postfix)
class mysql($db_type) {

  $mybackuppw = hiera('mybackuppw', '')

  # mask mysql in case it gets pulled in via the USE flag; we want mariadb
  # instead
  file { "/etc/portage/package.mask/mysql":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.mask'],
    path => "/etc/portage/package.mask/mysql",
    source => "puppet:///files/mysql/etc/portage/package.mask/mysql",
  }

  # USE = extraengine
  file { "/etc/portage/package.use/mariadb":
    ensure  => present,
    owner   => "root",
    group   => "root",
    require => File['/etc/portage/package.use'],
    path    => "/etc/portage/package.use/mariadb",
    mode    => 0644,
    content => template("mysql/etc/portage/package.use/mariadb.erb"),
  }

  case $db_type {

    "master", "slave": {

      file { "/root/.my.cnf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => 0600,
        path    => "/root/.my.cnf",
        content => template("mysql/root/.my.cnf.erb"),
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

      service { 'mysql':
        ensure  => running,
        enable  => true,
        subscribe => File['/etc/mysql/my.cnf'],
        require => [
          Package[mariadb],
          File['/etc/mysql/my.cnf']
        ],
      }

    }

  }

  $packages = [
    "mariadb",
  ]

  $packages_require = [
    File["/etc/portage/package.mask/mysql"],
    File["/etc/portage/package.use/mariadb"],
    Package[mysql],
  ]

  # Make sure mysql is uninstalled
  package { mysql:
    ensure => absent,
  }

  package { mariadb:
    ensure  => installed,
    require => $packages_require,
  }

  # Only run once after the initial installation
  # runs configuration with defaults from conf.d/postgresql-9.3
  # TODO: Auto answer yes to the emerge question
  #exec { "mariadb_config":
  #  command => "/usr/bin/emerge --config -y mariadb",
  #  refreshonly => true,
  #  require => [
  #    Package[mariadb],
  #  ],
  #}

}
