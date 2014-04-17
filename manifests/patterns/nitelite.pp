# must overlay webserver

class nitelite($environment) {

  # Configs based on environments
  # staging, development or production

  # You will need to create config files with the proper environment prefixing
  # the domain name.
  define website ($websiteName, $environmentName) {

    if $environmentName == "production" {
      $realWebsiteName = "${websiteName}"
    }
    else {
      $realWebsiteName = "${environmentName}.${websiteName}"
    }

    file { "/etc/nginx/sites-available/${realWebsiteName}":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/etc/nginx/sites-available/${realWebsiteName}",
      source => "puppet:///files/nitelite/etc/nginx/sites-available/${realWebsiteName}",
      require => File["/etc/nginx/sites-available"],
    }

    file { "/etc/nginx/sites-enabled/${realWebsiteName}":
       ensure => "link",
       target => "/etc/nginx/sites-available/${realWebsiteName}",
    }
  }

  website { "hackbytes.com":
    websiteName     => "hackbytes.com",
    environmentName => "${environment}",
  }

  website { "chompix.com":
    websiteName     => "chompix.com",
    environmentName => "${environment}",
  }

  website { "nitelite.io":
    websiteName     => "nitelite.io",
    environmentName => "${environment}",
  }

  website { "tehpotatoking.com":
    websiteName     => "tehpotatoking.com",
    environmentName => "${environment}",
  }

  file { "/etc/sudoers.d/deployer":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '440',
    require => File['/etc/sudoers.d'],
    path => "/etc/sudoers.d/deployer",
    source => "puppet:///files/nitelite/etc/sudoers.d/deployer",
  }

  file { "/etc/exim":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/exim/auth_conf.sub":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/exim/auth_conf.sub",
    source => "puppet:///files/nitelite/etc/exim/auth_conf.sub",
    require => File["/etc/exim"],
  }

  file { "/etc/exim/exim.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/exim/exim.conf",
    source => "puppet:///files/nitelite/etc/exim/exim.conf",
    require => File["/etc/exim"],
  }

  file { "/etc/exim/system_filter.exim":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/exim/system_filter.exim",
    source => "puppet:///files/nitelite/etc/exim/system_filter.exim",
    require => File["/etc/exim"],
  }

  # TODO: Install PECL YAML extension
  # TODO: development vs production param for php.ini
  file { "/etc/portage/package.use/php":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/php",
    source => "puppet:///files/nitelite/etc/portage/package.use/php",
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

  file { "/etc/php/fpm-php5.5/php-fpm.conf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/php/fpm-php5.5'],
    path => "/etc/php/fpm-php5.5/php-fpm.conf",
    source => "puppet:///files/nitelite/etc/php/fpm-php5.5/php-fpm.conf",
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
    source => "puppet:///files/nitelite/etc/php/fpm-php5.5/pool.d/www.conf",
  }

  $packages = [
    "nodejs",
    "php",
    "pecl-yaml",
    "exim",
    "sqlite3",
  ]

  package { $packages: ensure => installed }

  service { 'php-fpm':
    ensure => running,
    enable => true,
    subscribe => File['/etc/php/fpm-php5.5/php-fpm.conf'],
    require   => [
      File['/etc/php/fpm-php5.5/php-fpm.conf'],
      Package[php],
    ],
  }

}
