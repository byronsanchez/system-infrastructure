# must overlay webserver

class nitelite($environment) {

  nl_nginx::website { "hackbytes.com":
    websiteName     => "hackbytes.com",
    environmentName => "${environment}",
    root_path       => "/htdocs",
    enable_php      => true,
    enable_feed     => true,
    feed_path       => "hackbytes",
  }

  # nl_nginx::website { "tehpotatoking.com":
  #   websiteName     => "tehpotatoking.com",
  #   environmentName => "${environment}",
  #   root_path       => "/htdocs",
  #   enable_php      => true,
  #   enable_feed     => true,
  #   feed_path       => "tehpotatoking",
  # }

  $packages = [
    "sqlite3",
  ]

  package { $packages: ensure => installed }

}
