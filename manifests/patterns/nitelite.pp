# must overlay webserver

class nitelite($environment) {

  nl_nginx::website { "hackbytes.com":
    websiteName     => "hackbytes.com",
    environmentName => "${environment}",
    feed_path       => "hackbytes",
    root_path       => "/current/_site"
  }

  nl_nginx::website { "chompix.com":
    websiteName     => "chompix.com",
    environmentName => "${environment}",
    feed_path       => "byronsanchez",
  }

  nl_nginx::website { "nitelite.io":
    websiteName     => "nitelite.io",
    environmentName => "${environment}",
    feed_path       => "nitelite",
    root_path       => "/current/build"
  }

  nl_nginx::website { "tehpotatoking.com":
    websiteName     => "tehpotatoking.com",
    environmentName => "${environment}",
    feed_path       => "tehpotatoking",
  }

  $packages = [
    "sqlite3",
  ]

  package { $packages: ensure => installed }

}
