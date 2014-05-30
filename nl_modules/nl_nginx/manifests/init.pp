class nl_nginx {

  # TODO: implement nginx.conf.erb

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
    $port = '80',
    $disable_www = true,
    $enable_feed = false,
    $enable_custom_configs = false,
    $enable_ssl = false,
    $enable_php = false,
    $enable_cgi = false,
    $php_server = 'unix:/var/run/php5-fpm.sock',
    $cgi_server = '127.0.0.1:3128',
    $ssl_cert_path = '',
    $ssl_key_path = '',
    $upstream = false,
    $upstream_server = false,
    $proxy_pass = false,
    $proxy_cookie_path = false,
    $proxy_redirect = false,
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

  # TODO: subscribe to all site configs and nginx config
  service { nginx:
    ensure    => running,
    enable => true,
    require   => [
      Package[nginx],
    ],
  }

}
