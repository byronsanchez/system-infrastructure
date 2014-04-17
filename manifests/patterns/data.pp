class data {

  $packages = [
    "sensu",
    "smokeping",
    "rabbit-mq-server",
    "flapjack",
    #"syslog-ng",
    #"logrotate",
    "logstash",
    "graphite",
    "statsd",
    "kibana",
    "elastic-search"
  ]

  package {
    $packages: ensure => "installed",
  }

  service { 'syslog-ng':
    ensure => 'running',
    enable => 'true',
  }

}
