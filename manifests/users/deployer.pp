class deployer {

  $passwords = hiera("passwords", "")

  if $passwords {
    $password = $passwords['deployer']
  }

  if $password {

    user { 'deployer':
      ensure     => 'present',
      managehome => true,
      gid        => 'www-data',
      home       => '/home/deployer',
      shell      => '/bin/sh',
      uid        => '1002',
      password   => $password,
    }

    group { 'deployer':
      ensure => 'present',
      gid  => '1002',
    }

  }

}

