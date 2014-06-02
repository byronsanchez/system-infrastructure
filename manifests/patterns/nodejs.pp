class nodejs {

  nl_homedir::file { "deployer_npmrc":
    file  => ".npmrc",
    user => "deployer",
    mode => 0644,
    owner   => 'deployer',
    group   => 'nginx',
  }

  nl_homedir::file { "deployer_profile":
    file  => ".profile",
    user => "deployer",
    mode => 0644,
    owner   => 'deployer',
    group   => 'nginx',
  }

  $packages = [
    "nodejs",
  ]

  package { $packages: ensure => installed }

}
