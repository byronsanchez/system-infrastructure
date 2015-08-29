class java(
  $java_type = '',
) {

  if $java_type == "server" {

    file { "/var/lib/tomcat": 
      ensure  => directory,
      owner   => 'tomcat',
      group   => 'tomcat',
      mode    => 0755,
      require => Package[tomcat],
    }

    package { 'tomcat':
      ensure => installed,
      notify => Exec['usermod_tomcat'],
    }

    service { "tomcat-7": 
      ensure    => running,
      enable => true,
      require   => [
        Package[tomcat],
        Exec[create_tomcat_instance],
      ],
    }

    exec { "create_tomcat_instance":
      command => "/usr/share/tomcat-7/gentoo/tomcat-instance-manager.bash --create",
      creates => File['/etc/init.d/tomcat-7'],
    }

    # switch tomcat's homedir from none to /var/lib/tomcat. This is needed since
    # gitbucket uses the homedir to create the database storage.
    exec { "usermod_tomcat":
      command     => "/usr/sbin/usermod -d /var/lib/tomcat tomcat",
      refreshonly => true,
      require     => Package[tomcat],
    }

  }

  file { "/etc/portage/package.license/java":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.license'],
    path => "/etc/portage/package.license/java",
    source => "puppet:///files/java/etc/portage/package.license/java",
  }

  file { "/etc/portage/package.use/java":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/java",
    source => "puppet:///files/java/etc/portage/package.use/java",
  }

  $packages = [
    "icedtea-bin",
  ]

  $packages_require = [
    File["/etc/portage/package.license/java"],
    File["/etc/portage/package.use/java"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  package { "oracle-jdk-bin":
    ensure  => installed,
    require => [
      File['/etc/portage/package.license/java'],
      Exec['download_oracle_java'],
    ]
  }

  exec { "download_oracle_java":
    command => "/usr/bin/wget -P /usr/portage/distfiles http://binhost.internal.nitelite.io/external/distfiles/jdk-7u55-linux-x64.tar.gz",
    creates => "/usr/portage/distfiles/jdk-7u55-linux-x64.tar.gz",
  }

  eselect { 'java-vm':
    set => 'oracle-jdk-bin-1.7',
  }

  layman { 'java':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  # TODO: ensure certs are installed into java AND requires oracle bin eselect

}
