class ci {

  file { "/etc/portage/package.accept_keywords/jenkins":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/jenkins",
    source => "puppet:///files/ci/etc/portage/package.accept_keywords/jenkins",
  }

  file { "/etc/portage/package.use/jenkins":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/jenkins",
    source => "puppet:///files/ci/etc/portage/package.use/jenkins",
  }

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

  nl_homedir::file { "jenkins_bashrc":
    file  => ".bashrc",
    user  => "jenkins",
    mode  => 0644,
    owner => 'jenkins',
    group => 'jenkins',
  }

  nl_homedir::file { "jenkins_profile":
    file  => ".profile",
    user => "jenkins",
    mode => 0644,
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  nl_homedir::file { "jenkins_zshrc":
    file  => ".zshrc",
    user => "jenkins",
    mode => 0644,
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  nl_homedir::file { "jenkins_npmrc":
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

  # Jenkins automatically disables all robots, so we don't have to specify our
  # implemention of robots.txt here.
  nl_nginx::website { "jenkins":
    websiteName       => "jenkins.nitelite.io",
    environmentName   => "production",
    feed_path         => "jenkins",
    root_path         => "/htdocs",
    enable_ssl        => true,
    ssl_cert_path   => "/etc/letsencrypt/live/jenkins.nitelite.io/fullchain.pem",
    ssl_key_path    => "/etc/letsencrypt/live/jenkins.nitelite.io/privkey.pem",
    proxy_pass      => "http://jenkinsserver",
    proxy_redirect  => "http://jenkins.nitelite.io:8080/ https://jenkins.nitelite.io/",
    upstream        => "jenkinsserver",
    # non-cgi scripts will be handled by the fossil server
    upstream_server => "localhost:8080",
  }

}
