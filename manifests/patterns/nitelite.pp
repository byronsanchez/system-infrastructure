# must overlay webserver

class nitelite($environment) {

  nl_nginx::website { "hackbytes.com":
    websiteName     => "hackbytes.com",
    environmentName => "${environment}",
    root_path       => "/current/_site",
    enable_php      => true,
    enable_feed     => true,
    feed_path       => "hackbytes",
  }

  nl_nginx::website { "chompix.com":
    websiteName     => "chompix.com",
    environmentName => "${environment}",
    enable_php      => true,
    enable_feed     => true,
    feed_path       => "byronsanchez",
  }

  nl_nginx::website { "nitelite.io":
    websiteName     => "nitelite.io",
    environmentName => "${environment}",
    root_path       => "/current/build",
    enable_php      => true,
    enable_feed     => true,
    feed_path       => "nitelite",
  }

  nl_nginx::website { "tehpotatoking.com":
    websiteName     => "tehpotatoking.com",
    environmentName => "${environment}",
    enable_php      => true,
    enable_feed     => true,
    feed_path       => "tehpotatoking",
  }

  $packages = [
    "sqlite3",
  ]

  package { $packages: ensure => installed }

}
