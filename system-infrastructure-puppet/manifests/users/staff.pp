class staff {

  $passwords = hiera("passwords", "")

  if $passwords {
    $password = $passwords['staff']
  }

  if $password {

    user { 'staff':
      ensure   => 'present',
      managehome => true,
      gid      => '1003',
      home     => '/home/staff',
      shell    => '/bin/bash',
      uid      => '1003',
      password => $password,
    }

  }
  else {

    user { 'staff':
      ensure => 'present',
      managehome => true,
      gid    => '1003',
      home   => '/home/staff',
      shell  => '/bin/bash',
      uid    => '1003',
    }

  }

  group { 'staff':
    ensure => 'present',
    gid    => '1003',
  }

}
