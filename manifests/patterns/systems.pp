class systems(
  $postfixadmin = false,
  $phpldapadmin = false,
  $cgit = false,
  $fossil = false,
  $jenkins = false,
) {

  nl_nginx::website { "systems":
    websiteName     => "systems.nitelite.io",
    environmentName => "production",
    feed_path       => "systems",
    root_path       => "/htdocs",
    enable_ssl      => true,
    enable_php      => true,
    ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
    ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
  }

  if $phpldapadmin {

    file { "/etc/portage/package.use/phpldapadmin":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/phpldapadmin",
      source => "puppet:///files/systems/etc/portage/package.use/phpldapadmin",
    }

    file { "/srv/www/systems.nitelite.io/htdocs/phpldapadmin/config/config.php":
      ensure => present,
      owner => "deployer",
      group => "www-data",
      require => [
        Package[phpldapadmin],
        Exec[webapp_config_phpldapadmin],
      ],
      path    => "/srv/www/systems.nitelite.io/htdocs/phpldapadmin/config/config.php",
      source => "puppet:///files/systems/srv/www/systems.nitelite.io/htdocs/phpldapadmin/config/config.php",
    }

    $phpldapadmin_packages = [
      "phpldapadmin",
    ]

    package { $phpldapadmin_packages: ensure => installed }

    exec { "webapp_config_phpldapadmin":
      command => "/usr/sbin/webapp-config -I -h systems.${domain} -d phpldapadmin phpldapadmin 1.2.3",
      creates => "/srv/www/systems.${domain}/htdocs/phpldapadmin",
      require => [
        Package[phpldapadmin],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

  }

  if $postfixadmin {

    $mailreaderpw = hiera('mailreaderpw', '')

    file { "/etc/portage/package.use/postfixadmin":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/postfixadmin",
      source => "puppet:///files/systems/etc/portage/package.use/postfixadmin",
    }

    file { "/srv/www/systems.nitelite.io/htdocs/postfixadmin/config.inc.php":
      ensure => present,
      owner => "deployer",
      group => "www-data",
      require => [
        Package[postfixadmin],
        Exec[webapp_config_postfixadmin],
      ],
      path    => "/srv/www/systems.nitelite.io/htdocs/postfixadmin/config.inc.php",
      content => template("systems/srv/www/systems.nitelite.io/htdocs/postfixadmin/config.inc.php.erb"),
    }

    $postfixadmin_packages = [
      "postfixadmin",
    ]

    package { $postfixadmin_packages: ensure => installed }

    exec { "webapp_config_postfixadmin":
      command => "/usr/sbin/webapp-config -I -h systems.${domain} -d postfixadmin postfixadmin 2.3.7",
      creates => "/srv/www/systems.${domain}/htdocs/postfixadmin",
      require => [
        Package[postfixadmin],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

  }

  if $cgit {

    # cgit internal frontend nginx for https
    nl_nginx::website { "git":
      websiteName     => "git.internal.nitelite.io",
      environmentName => "production",
      feed_path       => "git",
      root_path       => "/htdocs",
      enable_ssl      => true,
      ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass      => "http://cgitserver",
      proxy_redirect  => "http://cgit.internal.nitelite.io:8081/ https://git.internal.nitelite.io/",
      upstream        => "cgitserver",
      # non-cgi scripts will be handled by the fossil server
      upstream_server => "cgit.internal.nitelite.io:8081",
    }

  }

  if $fossil {

    # fossil internal frontend nginx for https
    nl_nginx::website { "fossil":
      websiteName     => "fossil.internal.nitelite.io",
      environmentName => "production",
      feed_path       => "fossil",
      root_path       => "/htdocs",
      enable_custom_configs => true,
      enable_ssl      => true,
      enable_cgi      => true,
      # cgi scripts sent here
      cgi_server      => "fs.internal.nitelite.io:3128",
      ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass      => "http://fossilserver",
      proxy_redirect  => "http://fs.internal.nitelite.io:4545/ https://fossil.internal.nitelite.io/",
      upstream        => "fossilserver",
      # non-cgi scripts will be handled by the fossil server
      upstream_server => "fs.internal.nitelite.io:4545",
    }

    file { "/etc/nginx/conf.d/nitelite/fossil.internal.nitelite.io":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/fossil.internal.nitelite.io",
      source =>
      "puppet:///files/systems/etc/nginx/conf.d/nitelite/fossil.internal.nitelite.io",
    }

  }

  if $jenkins {

    nl_nginx::website { "ci":
      websiteName       => "ci.nitelite.io",
      environmentName   => "production",
      feed_path         => "ci",
      root_path         => "/htdocs",
      enable_ssl        => true,
      ssl_cert_path     => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path      => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass        => "http://jenkins.internal.nitelite.io:8080",
    }

  }

}
