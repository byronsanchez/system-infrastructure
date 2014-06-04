class php(
  $php_timezone = '',
  $php_version = '',
  $environment = '',
) {

  if $php_version {
    eselect { 'php::fpm':
      set => "${php_version}",
    }
  }

  # TODO: Install PECL YAML extension
  # TODO: development vs production param for php.ini
  file { "/etc/portage/package.use/php":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/php",
    source => "puppet:///files/php/etc/portage/package.use/php",
  }

  file { "/etc/php":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/php/fpm-php5.5":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/php"],
  }

  file { "/etc/php/cli-php5.5":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/php"],
  }

  file { "/etc/php/fpm-php5.5/php-fpm.conf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/php/fpm-php5.5'],
    path => "/etc/php/fpm-php5.5/php-fpm.conf",
    source => "puppet:///files/php/etc/php/fpm-php5.5/php-fpm.conf",
  }

  file { "/etc/php/fpm-php5.5/pool.d":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/php/fpm-php5.5"],
  }

  file { "/etc/php/fpm-php5.5/pool.d/www.conf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/php/fpm-php5.5/pool.d'],
    path => "/etc/php/fpm-php5.5/pool.d/www.conf",
    source => "puppet:///files/php/etc/php/fpm-php5.5/pool.d/www.conf",
  }

  file { "/etc/php/fpm-php5.5/php.ini":
    ensure   => present,
    owner    => "root",
    group    => "root",
    require  => File['/etc/php/fpm-php5.5'],
    path     => "/etc/php/fpm-php5.5/php.ini",
    content => template("php/etc/php/fpm-php5.5/php.ini.erb"),
  }

  file { "/etc/php/cli-php5.5/php.ini":
    ensure   => present,
    owner    => "root",
    group    => "root",
    require  => File['/etc/php/cli-php5.5'],
    path     => "/etc/php/cli-php5.5/php.ini",
    content => template("php/etc/php/cli-php5.5/php.ini.erb"),
  }

  # 5.4 REDUNDANCY
  # TODO: Template this stuff

  file { "/etc/php/fpm-php5.4":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/php"],
  }

  file { "/etc/php/cli-php5.4":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/php"],
  }

  file { "/etc/php/fpm-php5.4/php-fpm.conf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/php/fpm-php5.4'],
    path => "/etc/php/fpm-php5.4/php-fpm.conf",
    source => "puppet:///files/php/etc/php/fpm-php5.4/php-fpm.conf",
  }

  file { "/etc/php/fpm-php5.4/pool.d":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/php/fpm-php5.4"],
  }

  file { "/etc/php/fpm-php5.4/pool.d/www.conf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/php/fpm-php5.4/pool.d'],
    path => "/etc/php/fpm-php5.4/pool.d/www.conf",
    source => "puppet:///files/php/etc/php/fpm-php5.4/pool.d/www.conf",
  }

  file { "/etc/php/fpm-php5.4/php.ini":
    ensure   => present,
    owner    => "root",
    group    => "root",
    require  => File['/etc/php/fpm-php5.4'],
    path     => "/etc/php/fpm-php5.4/php.ini",
    content => template("php/etc/php/fpm-php5.4/php.ini.erb"),
  }

  file { "/etc/php/cli-php5.4/php.ini":
    ensure   => present,
    owner    => "root",
    group    => "root",
    require  => File['/etc/php/cli-php5.4'],
    path     => "/etc/php/cli-php5.4/php.ini",
    content => template("php/etc/php/cli-php5.4/php.ini.erb"),
  }

  # Different apps require different versions (like ruby). For example,
  # phpldapadmin needs 5.4 for now, but I develop on 5.5. So make sure all
  # required versions are available and just eselect based on node's purpose.
  $packages = [
    "dev-lang/php:5.5",
    "dev-lang/php:5.4",
    "pecl-yaml",
  ]

  package { $packages: ensure => installed }

  service { 'php-fpm':
    ensure => running,
    enable => true,
    subscribe => [
      File['/etc/php/fpm-php5.5/php-fpm.conf'],
      File['/etc/php/fpm-php5.4/php-fpm.conf'],
    ],
    require   => [
      File['/etc/php/fpm-php5.5/php-fpm.conf'],
      File['/etc/php/fpm-php5.4/php-fpm.conf'],
      Package["dev-lang/php:5.4"],
      Package["dev-lang/php:5.5"],
    ],
  }

}
