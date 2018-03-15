class logger {

  user { 'logger':
    ensure => 'present',
    gid    => '1004',
    shell  => '/bin/false',
    uid    => '1004',
  }

  group { 'logger':
    ensure => 'present',
    gid    => '1004',
  }

}
