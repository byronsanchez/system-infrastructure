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

  file { '/var/lib/jenkins/.bashrc':
    ensure  => present,
    path => "/var/lib/jenkins/.bashrc",
    source => 'puppet:///files/ci/var/lib/jenkins/.bashrc',
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => 0644,
  }

  file { '/var/lib/jenkins/.profile':
    ensure  => present,
    path => "/var/lib/jenkins/.profile",
    source => 'puppet:///files/ci/var/lib/jenkins/.profile',
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => 0644,
  }

  file { '/var/lib/jenkins/.zshrc':
    ensure  => present,
    path => "/var/lib/jenkins/.zshrc",
    source => 'puppet:///files/ci/var/lib/jenkins/.zshrc',
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => 0644,
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
