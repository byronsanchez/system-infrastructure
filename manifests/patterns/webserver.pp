# Base configuration for nginx webserver
#
# binhost and nitelite can overlay this.

class webserver {

  # perms for any web apps
  # puppet will make all files 0644 and dirs will be 0755. If you want to
  # restrict dirs even further, these need to be individually set.
  # we'll let the applications decide how to set ownership and perms of files
  file { "/srv/www/":
    ensure  => 'directory',
    owner   => 'deployer',
    group   => 'nginx',
    mode    => 0640,
  }

  file { "/etc/nginx":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/nginx/nginx.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nginx/nginx.conf",
    source => "puppet:///files/webserver/etc/nginx/nginx.conf",
    require => File["/etc/nginx"],
  }

  file { "/etc/nginx/proxy_params":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nginx/proxy_params",
    source => "puppet:///files/webserver/etc/nginx/proxy_params",
    require => File["/etc/nginx"],
  }

  file { "/etc/nginx/conf.d":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/nginx"],
  }

  file { "/etc/nginx/conf.d/default.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nginx/conf.d/default.conf",
    source => "puppet:///files/webserver/etc/nginx/conf.d/default.conf",
    require => File["/etc/nginx/conf.d"],
  }

  file { "/etc/nginx/sites-available":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/nginx"],
  }

  file { "/etc/nginx/sites-available/default":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nginx/sites-available/default",
    source => "puppet:///files/webserver/etc/nginx/sites-available/default",
    require => File["/etc/nginx/sites-available"],
  }

  file { "/etc/nginx/sites-enabled":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/etc/nginx"],
  }

  file { "/etc/vhosts/webapp-config":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '644',
    path => "/etc/vhosts/webapp-config",
    source => "puppet:///files/webserver/etc/vhosts/webapp-config",
  }

  $packages = [
    "nginx",
  ]

  package { $packages: ensure => installed }

  service { 'nginx':
    ensure => running,
    enable => true,
    subscribe => File['/etc/nginx/nginx.conf'],
    require   => [
      File['/etc/nginx/nginx.conf'],
      Package[nginx],
    ],
  }

}
