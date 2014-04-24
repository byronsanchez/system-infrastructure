class deployer {

  user { 'deployer':
    ensure           => 'present',
    managehome => true,
    gid              => 'nginx',
    home             => '/home/deployer',
    shell            => '/bin/sh',
    uid              => '1002',
  }

  group { 'deployer':
    ensure => 'present',
    gid  => '1002',
  }

}
