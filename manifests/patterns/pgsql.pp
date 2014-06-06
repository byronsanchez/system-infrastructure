# can be server or slave. client is a generic localhost installation
class pgsql(
  $db_type,
  $pgmaster_address = '',
) {

  $pgreaderpw = hiera('pgreaderpw', '')
  $pgbackuppw = hiera('pgbackuppw', '')

  file { "/etc/conf.d/postgresql-9.3":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/conf.d/postgresql-9.3",
    source  => "puppet:///files/pgsql/etc/conf.d/postgresql-9.3",
  }

  file { "/etc/postgresql-9.3/postgresql.conf":
    ensure  => present,
    owner   => "postgres",
    group   => "postgres",
    path    => "/etc/postgresql-9.3/postgresql.conf",
    content => template("pgsql/etc/postgresql-9.3/postgresql.conf.erb"),
  }

  file { "/etc/postgresql-9.3/pg_ident.conf":
    ensure  => present,
    owner   => "postgres",
    group   => "postgres",
    path    => "/etc/postgresql-9.3/pg_ident.conf",
    content => template("pgsql/etc/postgresql-9.3/pg_ident.conf.erb"),
  }

  file { "/etc/postgresql-9.3/pg_hba.conf":
    ensure  => present,
    owner   => "postgres",
    group   => "postgres",
    path    => "/etc/postgresql-9.3/pg_hba.conf",
    content => template("pgsql/etc/postgresql-9.3/pg_hba.conf.erb"),
  }

  case $db_type {

    "master", "slave": {

      file { "/root/.pgpass":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => 0600,
        path    => "/root/.pgpass",
        content => template("pgsql/root/.pgpass.erb"),
      }

    }

  }


  if $db_type == "slave" {

    file { "/var/lib/postgresql/9.3/data/recovery.conf":
      ensure  => present,
      owner   => "postgres",
      group   => "postgres",
      path    => "/var/lib/postgresql/9.3/data/recovery.conf",
      content => template("pgsql/var/lib/postgresql/9.3/data/recovery.conf.erb"),
    }

  }

  $packages = [
    "postgresql-server",
  ]

  package { $packages: ensure => installed }

  service { 'postgresql-9.3':
    ensure    => running,
    enable => true,
    subscribe => File['/etc/postgresql-9.3/postgresql.conf'],
    require   => [
      File['/etc/postgresql-9.3/postgresql.conf'],
      Package[postgresql-server],
    ],
  }

  # Only run once after the initial installation
  # runs configuration with defaults from conf.d/postgresql-9.3
  # TODO: Auto answer yes to the emerge question
  #exec { "postgres_config":
  #  command => "/usr/bin/emerge --config -y postgresql-server",
  #  refreshonly => true,
  #  require => [
  #    Package[postgresql-server],
  #    File['/etc/conf.d/postgresql-9.3'],
  #  ],
  #}

}
