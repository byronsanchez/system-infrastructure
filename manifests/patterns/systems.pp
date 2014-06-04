class systems(
  $phpmyadmin = false,
  $phppgadmin = false,
  $phpldapadmin = false,
  $postfixadmin = false,
  $roundcube = false,
  $ampache = false,
  $gitbucket = false,
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

  if $phpmyadmin {

    file { "/srv/www/systems.nitelite.io/htdocs/phpmyadmin/config.inc.php":
      ensure => present,
      owner => "deployer",
      group => "www-data",
      require => [
        Package[phpmyadmin],
        Exec[webapp_config_phpmyadmin],
      ],
      path    => "/srv/www/systems.nitelite.io/htdocs/phpmyadmin/config.inc.php",
      source => "puppet:///files/systems/srv/www/systems.nitelite.io/htdocs/phpmyadmin/config.inc.php",
    }

    $phpmyadmin_packages = [
      "phpmyadmin",
    ]

    package { $phpmyadmin_packages: ensure => installed }

    exec { "webapp_config_phpmyadmin":
      command => "/usr/sbin/webapp-config -I -h systems.${domain} -d phpmyadmin phpmyadmin 4.1.7",
      creates => "/srv/www/systems.${domain}/htdocs/phpmyadmin",
      require => [
        Package[phpmyadmin],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

  }

  if $phppgadmin {

    file { "/srv/www/systems.nitelite.io/htdocs/phppgadmin/conf/config.inc.php":
      ensure => present,
      owner => "deployer",
      group => "www-data",
      require => [
        Package[phppgadmin],
        Exec[webapp_config_phppgadmin],
      ],
      path    => "/srv/www/systems.nitelite.io/htdocs/phppgadmin/conf/config.inc.php",
      source => "puppet:///files/systems/srv/www/systems.nitelite.io/htdocs/phppgadmin/conf/config.inc.php",
    }

    $phppgadmin_packages = [
      "phppgadmin",
    ]

    package { $phppgadmin_packages: ensure => installed }

    exec { "webapp_config_phppgadmin":
      command => "/usr/sbin/webapp-config -I -h systems.${domain} -d phppgadmin phppgadmin 5.1",
      creates => "/srv/www/systems.${domain}/htdocs/phppgadmin",
      require => [
        Package[phppgadmin],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

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

  if $roundcube {

    $roundcubereaderpw = hiera('roundcubereaderpw', '')

    file { "/srv/www/systems.nitelite.io/htdocs/roundcube/config/db.inc.php":
      ensure => present,
      owner => "deployer",
      group => "www-data",
      require => [
        Package[roundcube],
        Exec[webapp_config_roundcube],
      ],
      path    => "/srv/www/systems.nitelite.io/htdocs/roundcube/config/db.inc.php",
      content => template("systems/srv/www/systems.nitelite.io/htdocs/roundcube/config/db.inc.php.erb"),
    }

    file { "/srv/www/systems.nitelite.io/htdocs/roundcube/config/main.inc.php":
      ensure => present,
      owner => "deployer",
      group => "www-data",
      require => [
        Package[roundcube],
        Exec[webapp_config_roundcube],
      ],
      path    => "/srv/www/systems.nitelite.io/htdocs/roundcube/config/main.inc.php",
      source => "puppet:///files/systems/srv/www/systems.nitelite.io/htdocs/roundcube/config/main.inc.php",
    }

    $roundcube_packages = [
      "roundcube",
    ]

    package { $roundcube_packages: ensure => installed }

    exec { "webapp_config_roundcube":
      command => "/usr/sbin/webapp-config -I -h systems.${domain} -d roundcube roundcube 0.9.5",
      creates => "/srv/www/systems.${domain}/htdocs/roundcube",
      require => [
        Package[roundcube],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

  }

  if $ampache {

    $ampachereaderpw = hiera('ampachereaderpw', '')

    file { "/srv/www/systems.nitelite.io/htdocs/ampache/config/ampache.cfg.php":
      ensure => present,
      owner => "deployer",
      group => "www-data",
      require => [
        Package[ampache],
        Exec[webapp_config_ampache],
      ],
      path    => "/srv/www/systems.nitelite.io/htdocs/ampache/config/ampache.cfg.php",
      content => template("systems/srv/www/systems.nitelite.io/htdocs/ampache/config/ampache.cfg.php.erb"),
    }

    # TODO: require nitelite overlay
    $ampache_packages = [
      "ampache",
    ]

    package { $ampache_packages: ensure => installed }

    exec { "webapp_config_ampache":
      command => "/usr/sbin/webapp-config -I -h systems.${domain} -d ampache ampache 9999",
      creates => "/srv/www/systems.${domain}/htdocs/ampache",
      require => [
        Package[phppgadmin],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

  }

  # TODO: consider removing gitbucket in favor of cgit
  if $gitbucket {

    nl_nginx::website { "git":
      websiteName     => "git.nitelite.io",
      environmentName => "production",
      feed_path       => "git",
      root_path       => "/htdocs",
      enable_ssl      => true,
      ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      # trailing slash is REQUIRED
      proxy_pass      => "http://git.internal.nitelite.io:8080/gitbucket/",
      proxy_cookie_path => "/gitbucket ''",
      proxy_redirect  => "http://git.internal.nitelite.io:8080/gitbucket/ https://git.nitelite.io/"

    }

  }

  if $cgit {

    nl_nginx::website { "git":
      websiteName     => "git.nitelite.io",
      environmentName => "production",
      feed_path       => "git",
      root_path       => "/htdocs",
      enable_ssl      => true,
      ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass      => "http://cgitserver",
      proxy_redirect  => "http://cgit.internal.nitelite.io:8081/ https://git.nitelite.io/",
      upstream        => "cgitserver",
      # non-cgi scripts will be handled by the fossil server
      upstream_server => "cgit.internal.nitelite.io:8081",
    }

  }

  if $fossil {

    nl_nginx::website { "fossil":
      websiteName     => "fossil.nitelite.io",
      environmentName => "production",
      feed_path       => "fossil",
      root_path       => "/htdocs",
      enable_custom_configs => true,
      enable_ssl      => true,
      enable_cgi      => true,
      # cgi scripts sent here
      cgi_server      => "fossil.internal.nitelite.io:3128",
      ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass      => "http://fossilserver",
      proxy_redirect  => "http://fossil.internal.nitelite.io:4545/ https://fossil.nitelite.io/",
      upstream        => "fossilserver",
      # non-cgi scripts will be handled by the fossil server
      upstream_server => "fossil.internal.nitelite.io:4545",
    }

    file { "/etc/nginx/conf.d/nitelite/fossil.nitelite.io":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/fossil.nitelite.io",
      source => "puppet:///files/systems/etc/nginx/conf.d/nitelite/fossil.nitelite.io",
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
