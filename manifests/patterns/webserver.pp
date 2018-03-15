# Base configuration for nginx webserver
#
# binhost and nitelite can overlay this.

class webserver(
  $is_secure = false
) {

  # add base nginx resources
  class { "nl_nginx": }

  if $is_secure {

    file { "/etc/cron.daily/certbot":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/etc/cron.daily/certbot",
      source => "puppet:///files/webserver/etc/cron.daily/certbot",
      require => File["/etc/cron.daily"],
    }

    file { "/etc/portage/package.accept_keywords/cerbot":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.accept_keywords'],
      path => "/etc/portage/package.accept_keywords/certbot",
      source => "puppet:///files/webserver/etc/portage/package.accept_keywords/certbot",
    }

    $secure_packages = [
      "app-crypt/certbot",
      "app-crypt/certbot-nginx"
    ]

    package { $secure_packages:
      ensure => installed,
    }
  }

  # perms for any web apps
  # puppet will make all files 0644 and dirs will be 0755. If you want to
  # restrict dirs even further, these need to be individually set.
  # we'll let the applications decide how to set ownership and perms of files
  file { "/srv/www/":
    ensure  => 'directory',
    owner   => 'deployer',
    group   => 'www-data',
    mode    => 0750,
    require => File["/srv"],
  }

  file { "/var/lib/nitelite/deploy":
    ensure => 'directory',
    owner  => 'deployer',
    group  => 'www-data',
    mode    => 0750,
    require => Class["nl_nginx"],
  }

  file { "/var/lib/nitelite/webserver":
    ensure => 'directory',
    owner  => 'deployer',
    group  => 'www-data',
    mode    => 0750,
    require => Class["nl_nginx"],
  }

  file { "/etc/nginx/conf.d/nitelite":
    ensure => "directory",
    owner => "root",
    group => "root",
    require => Class["nl_nginx"],
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
    "app-admin/webapp-config",
  ]

  package { $packages:
    ensure => installed,
  }

}
