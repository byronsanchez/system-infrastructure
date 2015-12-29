class ruby {

  # root user configs

  nl_homedir::file { "root_bashrc":
    file  => ".bashrc",
    user  => "root",
    mode  => 0644,
    owner => 'root',
    group => 'root',
  }

  nl_homedir::file { "root_profile":
    file  => ".profile",
    user => "root",
    mode => 0644,
    owner   => 'root',
    group   => 'root',
  }

  nl_homedir::file { "root_zshrc":
    file  => ".zshrc",
    user => "root",
    mode => 0644,
    owner   => 'root',
    group   => 'root',
  }

  nl_homedir::file { "root_npmrc":
    file  => ".npmrc",
    user => "root",
    mode => 0644,
    owner   => 'root',
    group   => 'root',
  }


  nl_homedir::file { "root_rvmrc":
    file  => ".rvmrc",
    user => "root",
    mode => 0644,
    owner   => 'root',
    group   => 'root',
  }

  # staff user configs

  nl_homedir::file { "staff_bashrc":
    file  => ".bashrc",
    user  => "staff",
    mode  => 0644,
    owner => 'staff',
    group => 'staff',
  }

  nl_homedir::file { "staff_profile":
    file  => ".profile",
    user => "staff",
    mode => 0644,
    owner   => 'staff',
    group   => 'staff',
  }

  nl_homedir::file { "staff_zshrc":
    file  => ".zshrc",
    user => "staff",
    mode => 0644,
    owner   => 'staff',
    group   => 'staff',
  }

  nl_homedir::file { "staff_npmrc":
    file  => ".npmrc",
    user => "staff",
    mode => 0644,
    owner   => 'staff',
    group   => 'staff',
  }


  nl_homedir::file { "staff_rvmrc":
    file  => ".rvmrc",
    user => "staff",
    mode => 0644,
    owner   => 'staff',
    group   => 'staff',
  }


  nl_rvm::user_install { "root_rvm":
    user    => "root",
    home    => "/root",
    require => nl_homedir::file["root_rvmrc"]
  }

  # all nodes will have rvm for the staff user to provide the ruby environment to
  # run puppet
  nl_rvm::user_install { "staff_rvm":
    user    => "staff",
    home    => "/home/staff",
    require => nl_homedir::file["staff_rvmrc"]
  }

  # Install rvm to deployer to provide a production ruby environment (instead of
  # using system ruby)
  nl_rvm::user_install { "deployer_rvm":
    user    => "deployer",
    home    => "/home/deployer",
  }

  $packages = [
    # needed to compile rubies for rvm
    "net-misc/curl",
    "sys-devel/patch",
    "app-shells/bash",
    "virtual/libiconv",
    "sys-libs/readline",
    "sys-libs/zlib",
    "dev-libs/openssl",
    "dev-libs/libyaml",
    "dev-db/sqlite",
    "sys-devel/libtool",
    "sys-devel/gcc",
    "sys-devel/autoconf",
    "sys-devel/automake",
    "sys-devel/bison",
    "sys-devel/m4",
  ]

  package { $packages:
    ensure => installed,
  }

}
