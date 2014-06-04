class nodejs {

  nl_homedir::file { "deployer_npmrc":
    file  => ".npmrc",
    user => "deployer",
    mode => 0644,
    owner   => 'deployer',
    group   => 'www-data',
  }

  nl_homedir::file { "deployer_profile":
    file  => ".profile",
    user => "deployer",
    mode => 0644,
    owner   => 'deployer',
    group   => 'www-data',
  }

  $packages = [
    "nodejs",
  ]

  package { $packages: ensure => installed }

}
