class backup(
  $backup_type = '',
) {

  $nodes = hiera('nodes', '')
  $backup_uuid = hiera('backup_uuid', '')
  $backup_keyfile = hiera('backup_keyfile', '')

  if ($backup_type == "server") or ($backup_type == "workstation") {

    file { '/etc/rsnapshot.conf':
      ensure  => present,
      path    => "/etc/rsnapshot.conf",
      content => template('backup/etc/rsnapshot.conf.erb'),
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

    file { '/etc/cron.d/rsnapshot':
      ensure  => present,
      path    => "/etc/cron.d/rsnapshot",
      content => template('backup/etc/cron.d/rsnapshot.erb'),
      group   => '0',
      owner   => '0',
      require => File['/etc/cron.d'],
    }

    $server_packages = [
      "rsnapshot",
    ]

    package {
      $server_packages: ensure => installed,
    }

  }

  if $backup_type == "server" {

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

    file { '/usr/local/bin/backup-pgsql.sh':
      ensure  => present,
      path => "/usr/local/bin/backup-pgsql.sh",
      source => 'puppet:///files/backup/usr/local/bin/backup-pgsql.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '755',
    }

    file { '/usr/local/bin/backup-mysql.sh':
      ensure  => present,
      path => "/usr/local/bin/backup-mysql.sh",
      source => 'puppet:///files/backup/usr/local/bin/backup-mysql.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '755',
    }

    file { '/usr/local/bin/backup-ldap.sh':
      ensure  => present,
      path => "/usr/local/bin/backup-ldap.sh",
      source => 'puppet:///files/backup/usr/local/bin/backup-ldap.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '755',
    }

    file { '/usr/local/bin/backup-virsh.sh':
      ensure  => present,
      path    => "/usr/local/bin/backup-virsh.sh",
      content => template('backup/usr/local/bin/backup-virsh.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
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

  }

  elsif $backup_type == "workstation" {

    file { '/etc/tarsnapper.conf':
      ensure  => present,
      path    => "/etc/tarsnapper.conf",
      source  => 'puppet:///files/backup/etc/tarsnapper.conf',
      group   => '0',
      mode    => '644',
      owner   => '0',
    }

    file { '/usr/local/bin/backup-mirror.sh':
      ensure  => present,
      path    => "/usr/local/bin/backup-mirror.sh",
      content => template('backup/usr/local/bin/backup-mirror.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
    }

    vcsrepo { "/var/lib/nitelite/workstation/backups":
      ensure   => present,
      provider => git,
      source   => "https://github.com/byronsanchez/backups.git",
      require  => File["/var/lib/nitelite/workstation"],
    }

    exec { "install_workstation_backup_scripts":
      command => "/usr/local/bin/install-workstation-backup-scripts",
      require => [
        Vcsrepo["/var/lib/nitelite/workstation/backups"],
        File["/usr/local/bin/install-workstation-backup-scripts"],
      ],
    }

    file { '/usr/local/bin/install-workstation-backup-scripts':
      ensure  => present,
      path => "/usr/local/bin/install-workstation-backup-scripts",
      source => 'puppet:///files/backup/usr/local/bin/install-workstation-backup-scripts',
      owner   => 'root',
      group   => 'root',
      mode    => '755',
    }

  }

  else {

    # If no server type was specified, assume the node is a client whose
    # contents will be backed up by a backup server.

    file { '/home/rbackup/validate-rsync.sh':
      ensure  => present,
      path => "/home/rbackup/validate-rsync.sh",
      source => 'puppet:///files/backup/home/rbackup/validate-rsync.sh',
      owner   => 'rbackup',
      group   => 'rbackup',
      mode    => '755',
    }

    file { '/usr/bin/rsync_wrapper.sh':
      ensure  => present,
      path => "/usr/bin/rsync_wrapper.sh",
      source => 'puppet:///files/backup/usr/bin/rsync_wrapper.sh',
      owner   => 'rbackup',
      group   => 'rbackup',
      mode    => '755',
    }

  }

  # every node gets a backup dir for dumpfiles. These files will then be
  # downloaded to the backup server, while retaining a copy in the var dir for
  # the target node.
  file { "/var/lib/nitelite/backup":
    ensure => 'directory',
    mode    => 0755,
    require => File["/var/lib/nitelite"],
  }

}
