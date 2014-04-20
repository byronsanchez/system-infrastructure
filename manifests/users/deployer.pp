class deployer {

  user { 'deployer':
    ensure           => 'present',
    gid              => '1002',
    home             => '/home/deployer',
    shell            => '/bin/sh',
    uid              => '1002',
  }

  group { 'deployer':
    ensure => 'present',
    gid  => '1002',
  }

}
