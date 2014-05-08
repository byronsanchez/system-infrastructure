class nodejs {

  file { '/home/deployer/.npmrc':
    ensure  => present,
    path => "/home/deployer/.npmrc",
    source => 'puppet:///files/nodejs/home/deployer/.npmrc',
    owner   => 'deployer',
    group   => 'deployer',
    mode    => 0644,
  }

  file { '/home/deployer/.profile':
    ensure  => present,
    path => "/home/deployer/.profile",
    source => 'puppet:///files/nodejs/home/deployer/.profile',
    owner   => 'deployer',
    group   => 'deployer',
    mode    => 0644,
  }

  $packages = [
    "nodejs",
    "dev-nodejs/nvm",
  ]

  package { $packages: ensure => installed }

}
