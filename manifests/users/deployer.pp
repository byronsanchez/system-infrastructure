class deployer {

  user { 'deployer':
    ensure           => 'present',
    #gid              => '33',
    home             => '/home/deployer',
    shell            => '/bin/sh',
    uid              => '1001',
  }

  group { 'deployer':
    ensure => 'present',
    gid  => '1001',
  }

}
