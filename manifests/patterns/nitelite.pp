# must overlay webserver

class nitelite($environment) {

  nl_nginx::website { "hackbytes.com":
    websiteName     => "hackbytes.com",
    environmentName => "${environment}",
    feed_path       => "hackbytes",
    root_path       => "/current/_site"
  }

  nl_nginx::website { "chompix.com":
    websiteName     => "chompix.com",
    environmentName => "${environment}",
    feed_path       => "byronsanchez",
  }

  nl_nginx::website { "nitelite.io":
    websiteName     => "nitelite.io",
    environmentName => "${environment}",
    feed_path       => "nitelite",
    root_path       => "/current/build"
  }

  nl_nginx::website { "tehpotatoking.com":
    websiteName     => "tehpotatoking.com",
    environmentName => "${environment}",
    feed_path       => "tehpotatoking",
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
  $packages = [
    "nodejs",
    "exim",
    "sqlite3",
  ]

  package { $packages: ensure => installed }

}
