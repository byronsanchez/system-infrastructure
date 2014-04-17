class rbackup {

  user { 'rbackup':
    ensure => 'present',
    gid    => '1002',
    home   => '/home/rbackup',
    shell  => '/bin/bash',
    uid    => '1002',
  }

  group { 'rbackup':
    ensure => 'present',
    gid    => '1002',
  }

}
