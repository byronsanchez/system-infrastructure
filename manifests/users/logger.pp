class logger {

  user { 'logger':
    ensure => 'present',
    gid    => '1004',
    shell  => '/bin/sh',
    uid    => '1004',
  }

  group { 'logger':
    ensure => 'present',
    gid    => '1004',
  }

}
