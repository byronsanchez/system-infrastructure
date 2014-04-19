# must overlay webserver 
# must overlay rsyncd

class binhost {

  file { "/etc/nginx/sites-available/binhost.internal.nitelite.io":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nginx/sites-available/binhost.internal.nitelite.io",
    source => "puppet:///files/binhost/etc/nginx/sites-available/binhost.internal.nitelite.io",
    require => File["/etc/nginx/sites-available"],
  }

  file { '/etc/nginx/sites-enabled/binhost.internal.nitelite.io':
     ensure => 'link',
     target => '/etc/nginx/sites-available/binhost.internal.nitelite.io',
  }

  file { "/srv/www/binhost.internal.nitelite.io":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    require => File["/srv/www"],
  }

  file { "/etc/cron.daily/mirror_gentoo":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/etc/cron.daily/mirror_gentoo",
    source => "puppet:///files/binhost/etc/cron.daily/mirror_gentoo",
    require => File["/etc/cron.daily"],
  }

  file { "/etc/cron.daily/mirror_gentoo_local":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/etc/cron.daily/mirror_gentoo_local",
    source => "puppet:///files/binhost/etc/cron.daily/mirror_gentoo_local",
    require => File["/etc/cron.daily"],
  }

  if $portage_package_directory {
    # link portage tree (ebuilds) to be accessible via http
    file { '/srv/www/binhost.internal.nitelite.io/packages':
       ensure  => 'link',
       target  => "${portage_package_directory}",
       require => File["/srv/www"],
    }
  }

  file { "/etc/rsyncd.d/binhost.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/rsyncd.d/binhost.conf",
    source => "puppet:///files/binhost/etc/rsyncd.d/binhost.conf",
    require => File["/etc/rsyncd.d"],
  }

  # Make the entire gentoo mirror available via rsync and http
  if $gentoo_directory {
    file { "/srv/rsync/gentoo":
      ensure  => "link",
      target  => "${gentoo_directory}",
      require => File["/srv/rsync"],
    }

    # TODO:
    # Link distfiles, snapshots, releases to be accessible via http
    # When the full mirror is done, this part uses that mirror for snapshots and
    # stages
    file { '/srv/www/binhost.internal.nitelite.io/gentoo':
       ensure  => 'link',
       target  => "${gentoo_directory}",
       require => File["/srv/www/binhost.internal.nitelite.io"],
    }
  }

  # Make the portage tree available via rsync
  if $portage_tree_directory {
    file { "/srv/rsync/gentoo-portage":
      ensure  => 'link',
      target  => "${portage_tree_directory}",
      require => File["/srv/rsync"],
    }
  }

}
