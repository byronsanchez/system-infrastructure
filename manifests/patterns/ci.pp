class ci {

  file { "/var/lib/jenkins/.ssh/jenkins_rsa":
    ensure => present,
    owner => "jenkins",
    group => "jenkins",
    mode => 0600,
    path => "/var/lib/jenkins/.ssh/jenkins_rsa",
    source => "puppet:///secure/ssh/jenkins_rsa",
  }

  file { "/var/lib/jenkins/.ssh/jenkins_rsa.pub":
    ensure => present,
    owner => "jenkins",
    group => "jenkins",
    mode => 0644,
    path => "/var/lib/jenkins/.ssh/jenkins_rsa.pub",
    source => "puppet:///secure/ssh/jenkins_rsa.pub",
  }

  nl_homedir::files { "jenkins_bashrc":
    file  => ".bashrc",
    user  => "jenkins",
    mode  => 0644,
    owner => 'jenkins',
    group => 'jenkins',
  }

  nl_homedir::files { "jenkins_profile":
    file  => ".profile",
    user => "jenkins",
    mode => 0644,
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  nl_homedir::files { "jenkins_zshrc":
    file  => ".zshrc",
    user => "jenkins",
    mode => 0644,
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  nl_homedir::files { "jenkins_npmrc":
    file  => ".npmrc",
    user => "jenkins",
    mode => 0644,
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  # TODO: require nitelite overlays
  $packages = [
    "jenkins-bin",
  ]

  # TODO: require nitelite overlays
  package {
    $packages: ensure => installed,
  }

  service { jenkins:
    ensure    => running,
    enable => true,
    require   => [
      Package[jenkins-bin],
    ],
  }

}
