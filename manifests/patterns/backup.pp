class backup {

  file { '/etc/rsnapshot.conf':
    ensure  => present,
    path => "/etc/rsnapshot.conf",
    source => 'puppet:///files/backup/etc/rsnapshot.conf',
    group   => '0',
    mode    => '644',
    owner   => '0',
  }

  file { '/etc/rsnapshot.exclude':
    ensure  => present,
    path => "/etc/rsnapshot.exclude",
    source => 'puppet:///files/backup/etc/rsnapshot.exclude',
    group   => '0',
    mode    => '644',
    owner   => '0',
  }

  file { '/etc/cron.daily/rsnapshot':
    ensure  => present,
    path    => "/etc/cron.daily/rsnapshot",
    source  => 'puppet:///files/backup/etc/cron.daily/rsnapshot',
    group   => '0',
    owner   => '0',
    mode    => 0755,
    require => File['/etc/cron.daily'],
  }

  file { '/etc/cron.weekly/rsnapshot':
    ensure  => present,
    path    => "/etc/cron.weekly/rsnapshot",
    source  => 'puppet:///files/backup/etc/cron.weekly/rsnapshot',
    group   => '0',
    owner   => '0',
    mode    => 0755,
    require => File['/etc/cron.weekly'],
  }

  file { '/etc/cron.monthly/rsnapshot':
    ensure  => present,
    path    => "/etc/cron.monthly/rsnapshot",
    source  => 'puppet:///files/backup/etc/cron.monthly/rsnapshot',
    group   => '0',
    owner   => '0',
    mode    => 0755,
    require => File['/etc/cron.monthly'],
  }

  $packages = [
    "rsnapshot",
  ]

  package {
    $packages: ensure => installed,
  }

}
