class nl_nginx {

  # websiteName = domain name without environment appended to the front (eg.
  # hackbytes.com)
  #
  # realWebsiteName = domain name WITH env appended to the front (eg.
  # stage.hackbytes.com)
  define website (
    $websiteName,
    $environmentName,
    $feed_path,
    $root_path = '',
    $enable_ssl = false,
    $ssl_cert_path = '',
    $ssl_key_path = '',
  ) {

    if $environmentName == "production" {
      $realWebsiteName = "${websiteName}"
    }
    else {
      $realWebsiteName = "${environmentName}.${websiteName}"
    }

    file { "/etc/nginx/sites-available/${realWebsiteName}":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/etc/nginx/sites-available/${realWebsiteName}",
      content => template("nl_nginx/etc/nginx/sites-available/website.erb"),
      require => File["/etc/nginx/sites-available"],
    }

    file { "/etc/nginx/sites-enabled/${realWebsiteName}":
       ensure => "link",
       target => "/etc/nginx/sites-available/${realWebsiteName}",
    }
  }

}
