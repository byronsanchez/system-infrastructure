class byronsanchez ($groups = ['audio', 'cdrom', 'usb',]) {

  $passwords = hiera("passwords", "")

  if $passwords {
    $password = $passwords['byronsanchez']
  }

  if $password {

    user { 'byronsanchez':
      ensure     => present,
      managehome => true,
      gid        => '1000',
      groups     => $groups,
      home       => '/home/byronsanchez',
      shell      => '/bin/zsh',
      uid        => '1000',
      password => $password,
      require    => [
        Package['app-shells/zsh'],
      ]
    }

  }
  else {

    user { 'byronsanchez':
      ensure     => present,
      managehome => true,
      gid        => '1000',
      groups     => $groups,
      home       => '/home/byronsanchez',
      shell      => '/bin/zsh',
      uid        => '1000',
      require    => [
        Package['app-shells/zsh'],
      ]
    }

  }

  group { 'byronsanchez':
    ensure => 'present',
    gid    => '1000',
  }

  file { "/etc/sudoers.d/byronsanchez":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => '440',
    path => "/etc/sudoers.d/byronsanchez",
    source => "puppet:///files/users/etc/sudoers.d/byronsanchez",
  }

}
