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

  # Install nvm to deployer to provide a production node environment (instead of
  # using system node)
  nl_nvm::user_install { "deployer_nvm":
    user    => "deployer",
    home    => "/home/deployer",
    require => [ 
      nl_homedir::file["deployer_npmrc"],
      nl_homedir::file["deployer_profile"],
    ],
  }

  $packages = [
    "nodejs",
  ]

  package { $packages: ensure => installed }

}
