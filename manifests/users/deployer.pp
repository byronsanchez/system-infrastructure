class deployer {

  user { 'deployer':
    ensure           => 'present',
    managehome => true,
    gid              => 'www-data',
    home             => '/home/deployer',
    shell            => '/bin/sh',
    uid              => '1002',
  }

  group { 'deployer':
    ensure => 'present',
    gid  => '1002',
  }

}
