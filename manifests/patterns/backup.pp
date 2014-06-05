class backup(
  $backup_type = '',
) {

  if $vcs_type == "server" {

    file { "/home/rbackup/.ssh/rbackup_rsa":
      ensure => present,
      owner => "rbackup",
      group => "rbackup",
      mode => 0600,
      path => "/home/rbackup/.ssh/rbackup_rsa",
      source => "puppet:///secure/ssh/rbackup_rsa",
    }

    file { "/home/rbackup/.ssh/rbackup_rsa.pub":
      ensure => present,
      owner => "rbackup",
      group => "rbackup",
      mode => 0644,
      path => "/home/rbackup/.ssh/rbackup_rsa.pub",
      source => "puppet:///secure/ssh/rbackup_rsa.pub",
    }

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

    file { '/etc/cron.daily/backup_mirror':
      ensure  => present,
      path    => "/etc/cron.daily/backup_mirror",
      source  => 'puppet:///files/backup/etc/cron.daily/backup_mirror',
      group   => '0',
      owner   => '0',
      mode    => 0755,
      require => File['/etc/cron.daily'],
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

    $server_packages = [
      "rsnapshot",
    ]

    package {
      $server_packages: ensure => installed,
    }

  }

  file { '/home/rbackup/validate-rsync.sh':
    ensure  => present,
    path => "/home/rbackup/validate-rsync.sh",
    source => 'puppet:///files/backup/home/rbackup/validate-rsync.sh',
    owner   => 'rbackup',
    group   => 'rbackup',
    mode    => '755',
  }

  file { '/usr/local/bin/rsync_wrapper.sh':
    ensure  => present,
    path => "/usr/local/bin/rsync_wrapper.sh",
    source => 'puppet:///files/backup/usr/local/bin/rsync_wrapper.sh',
    owner   => 'rbackup',
    group   => 'rbackup',
    mode    => '755',
  }

}
