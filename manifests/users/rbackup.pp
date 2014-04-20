class rbackup {

  user { 'rbackup':
    ensure => 'present',
    gid    => '1001',
    home   => '/home/rbackup',
    shell  => '/bin/bash',
    uid    => '1001',
  }

  group { 'rbackup':
    ensure => 'present',
    gid    => '1001',
  }

}
