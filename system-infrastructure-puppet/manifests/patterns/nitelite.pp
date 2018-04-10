# must overlay webserver

class nitelite($environment) {

  nl_nginx::website { "hackbytes.io":
    websiteName     => "hackbytes.io",
    environmentName => "${environment}",
    feed_path       => "hackbytes",
    root_path       => "/htdocs",
    enable_php      => true,
    enable_feed     => true,
    enable_ssl      => true,
    ssl_cert_path   => "/etc/letsencrypt/live/hackbytes.io/fullchain.pem",
    ssl_key_path    => "/etc/letsencrypt/live/hackbytes.io/privkey.pem",
  }

  # nl_nginx::website { "hackbytes.com":
  #   websiteName     => "hackbytes.com",
  #   environmentName => "${environment}",
  #   feed_path       => "hackbytes",
  #   root_path       => "/htdocs",
  #   enable_php      => true,
  #   enable_feed     => true,
  #   enable_ssl      => true,
  #   ssl_cert_path   => "/etc/letsencrypt/live/hackbytes.com/fullchain.pem",
  #   ssl_key_path    => "/etc/letsencrypt/live/hackbytes.com/privkey.pem",
  # }

  # just a demo site now for the portfolio
  # the main site has moved to hackbytes.io
  nl_nginx::website { "demo.hackbytes.com":
    websiteName     => "demo.hackbytes.com",
    environmentName => "${environment}",
    feed_path       => "hackbytes",
    root_path       => "/htdocs",
    enable_php      => true,
    enable_feed     => true,
    enable_ssl      => true,
    ssl_cert_path   => "/etc/letsencrypt/live/demo.hackbytes.com/fullchain.pem",
    ssl_key_path    => "/etc/letsencrypt/live/demo.hackbytes.com/privkey.pem",
  }

  nl_nginx::website { "byronsanchez.io":
    websiteName     => "byronsanchez.io",
    environmentName => "${environment}",
    feed_path       => "byronsanchez",
    root_path       => "/htdocs",
    enable_php      => true,
    enable_feed     => true,
    enable_ssl      => true,
    ssl_cert_path   => "/etc/letsencrypt/live/byronsanchez.io/fullchain.pem",
    ssl_key_path    => "/etc/letsencrypt/live/byronsanchez.io/privkey.pem",
  }

  nl_nginx::website { "nitelite.io":
    websiteName     => "nitelite.io",
    environmentName => "${environment}",
    feed_path       => "nitelite",
    root_path       => "/htdocs",
    enable_php      => true,
    enable_feed     => true,
    enable_ssl      => true,
    ssl_cert_path   => "/etc/letsencrypt/live/nitelite.io/fullchain.pem",
    ssl_key_path    => "/etc/letsencrypt/live/nitelite.io/privkey.pem",
  }

  nl_nginx::website { "byronfsanchez.com":
    websiteName     => "byronfsanchez.com",
    environmentName => "${environment}",
    feed_path       => "byronsanchez",
    root_path       => "/htdocs",
    enable_php      => true,
    enable_feed     => true,
    enable_ssl      => true,
    ssl_cert_path   => "/etc/letsencrypt/live/byronfsanchez.com/fullchain.pem",
    ssl_key_path    => "/etc/letsencrypt/live/byronfsanchez.com/privkey.pem",
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
