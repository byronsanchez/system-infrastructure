class data($data_type) {

  # TODO: ensure the graphital script exists on target system
  # this would fall under same scope of dotfiles 3rd party stuff. this script is MIT.
  # see: https://github.com/rashidkpc/graphital

  if $data_type == "server" {

    $server_packages = [
      "smokeping",
      "elasticsearch",
      "graphite-web",
      # needed by graphital scripts
      "daemons",
      # TODO: make logstash ebuild
      #"logstash",
      # TODO: make a kibana ebuild
      #"kibana",
    ]

    package {
      $server_packages: ensure => "installed",
    }

    $ruby_gems = [
      "sensu",
      "flapjack",
      "statsd",
    ]

    package { $ruby_gems:
      ensure  => installed,
      provider => 'gem',
      require => [
        Eselect[ruby],
      ],
    }

  }

  file { "/etc/logrotate.d":
    ensure => "directory",
    owner   => "root",
    group   => "root",
  }

  file { "/etc/cron.daily/logrotate":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0755,
    require => File['/etc/cron.daily'],
    path    => "/etc/cron.daily/logrotate",
    source  => "puppet:///files/data/etc/cron.daily/logrotate",
  }

  file { "/etc/cron.weekly/elog-cleanup":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0755,
    require => File['/etc/cron.weekly'],
    path    => "/etc/cron.weekly/elog-cleanup",
    source  => "puppet:///files/data/etc/cron.weekly/elog-cleanup",
  }

  file { "/etc/syslog-ng/syslog-ng.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/syslog-ng/syslog-ng.conf",
    content => template("data/etc/syslog-ng/syslog-ng.conf.erb"),
    require => Class[logger],
  }

  file { "/etc/logrotate.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/logrotate.conf",
    source  => "puppet:///files/data/etc/logrotate.conf",
  }

  file { "/etc/logrotate.d/syslog-ng":
    ensure  => present,
    owner   => "root",
    group   => "root",
    require => File['/etc/logrotate.d'],
    path    => "/etc/logrotate.d/syslog-ng",
    content => template("data/etc/logrotate.d/syslog-ng.erb"),
  }

  $packages = [
    "syslog-ng",
    "logrotate",
  ]

  package {
    $packages: ensure => "installed",
  }

  service { 'syslog-ng':
    ensure  => running,
    enable  => true,
    subscribe => File['/etc/syslog-ng/syslog-ng.conf'],
    require => [
      Package[syslog-ng],
      File['/etc/syslog-ng/syslog-ng.conf']
    ],
  }

  file { "/usr/local/share/ca-certificates/nitelite.io/data.crt":
    ensure  => present,
    owner   => "root",
    group   => "root",
    require => File['/usr/local/share/ca-certificates/nitelite.io'],
    path    => "/usr/local/share/ca-certificates/nitelite.io/data.crt",
    source  => "puppet:///secure/ssl/data/cacert.pem",
  }

  exec { "certificates_update_data":
    command => "/usr/sbin/update-ca-certificates",
    subscribe   => File['/etc/ca-certificates.conf'],
    require => [
      Package['ca-certificates'],
      File['/etc/ca-certificates.conf'],
      File['/usr/local/share/ca-certificates/nitelite.io/data.crt'],
    ],
  }

}
