# must overlay webserver
# must overlay rsyncd

class binhost(
  $portage_package_directory = '',
  $portage_directory = '',
  $portage_tree_directory = '',
  $gentoo_directory = '',
  $application_directory = '',
  $overlay_a = '',
  $overlay_b = '',
  $external_directory = '',
  $boxes_directory = '',
) {

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

  file { "/etc/cron.daily/mirror_overlays":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/etc/cron.daily/mirror_overlays",
    source => "puppet:///files/binhost/etc/cron.daily/mirror_overlays",
    require => File["/etc/cron.daily"],
  }

  file { "/usr/local/bin/publish-gentoo-updates":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/publish-gentoo-updates",
    source => "puppet:///files/binhost/usr/local/bin/publish-gentoo-updates",
  }

  if $portage_package_directory {
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

    file { '/srv/www/binhost.internal.nitelite.io/gentoo':
       ensure  => 'link',
       target  => "${gentoo_directory}",
       require => File["/srv/www/binhost.internal.nitelite.io"],
    }
  }

  # Make the application distfiles available over http
  if $application_directory {
    file { '/srv/www/binhost.internal.nitelite.io/nitelite-applications':
       ensure  => 'link',
       target  => "${application_directory}",
       require => File["/srv/www/binhost.internal.nitelite.io"],
    }

    file { $application_directory:
      ensure  => directory,
      owner   => "deployer",
      group   => "www-data",
      recurse => true,
    }
  }

  # TODO: abstract all these symlinks into a better design
  if $overlay_a {
    file { '/srv/www/binhost.internal.nitelite.io/nitelite-a':
       ensure  => 'link',
       target  => "${overlay_a}",
       require => File["/srv/www/binhost.internal.nitelite.io"],
    }
  }

  if $overlay_b {
    file { '/srv/www/binhost.internal.nitelite.io/nitelite-b':
       ensure  => 'link',
       target  => "${overlay_b}",
       require => File["/srv/www/binhost.internal.nitelite.io"],
    }
  }

  # Make the local portage tree available via rsync
  if $portage_directory {
    file { "/srv/rsync/gentoo-local-portage":
      ensure  => 'link',
      target  => "${portage_directory}",
      require => File["/srv/rsync"],
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

  # For manually retrieved files (eg. due to licenses)
  if $external_directory {
    file { '/srv/www/binhost.internal.nitelite.io/external':
       ensure  => 'link',
       target  => "${external_directory}",
       require => File["/srv/www/binhost.internal.nitelite.io"],
    }
  }

  # For provisioned boxes/images
  if $boxes_directory {
    file { '/srv/www/binhost.internal.nitelite.io/boxes':
       ensure  => 'link',
       target  => "${boxes_directory}",
       require => File["/srv/www/binhost.internal.nitelite.io"],
    }
  }

  file { "/srv/rsync/secrets":
    ensure  => 'directory',
    owner   => 'root',
    group => 'root',
    require => File["/srv/rsync"],
  }

  $packages = [
    "catalyst",
  ]

  package {
    $packages: ensure => installed,
  }

}
