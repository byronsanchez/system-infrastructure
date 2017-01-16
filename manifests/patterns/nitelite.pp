# must overlay webserver

class nitelite($environment) {

  nl_nginx::website { "hackbytes.com":
    websiteName     => "hackbytes.com",
    environmentName => "${environment}",
    feed_path       => "hackbytes",
    root_path       => "/htdocs",
    enable_php      => true,
    enable_feed     => true,
    enable_ssl      => true,
    ssl_cert_path   => "/etc/letsencrypt/live/hackbytes.com/fullchain.pem",
    ssl_key_path    => "/etc/letsencrypt/live/hackbytes.com/privkey.pem",
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
