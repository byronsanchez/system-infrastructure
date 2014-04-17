class byronsanchez ($groups = ['audio', 'cdrom', 'usb',]) {

  user { 'byronsanchez':
    ensure     => present,
    managehome => true,
    gid        => '1000',
    groups     => $groups,
    home       => '/home/byronsanchez',
    shell      => '/bin/zsh',
    uid        => '1000',
    require    => [
      Package[zsh],
      Package[zsh-completion],
    ]
  }

  group { 'byronsanchez':
    ensure => 'present',
    gid    => '1000',
  }

}
