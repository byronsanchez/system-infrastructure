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
    $enable_basic_auth = false,
    $enable_root_location = false,
    $disable_robots = false,
    $php_server = 'unix:/var/run/php-fpm.sock',
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

    file { "/srv/www/${realWebsiteName}":
			ensure => "directory",
      owner   => 'deployer',
      group   => 'www-data',
    }

    file { "/srv/www/${realWebsiteName}/$root_path":
			ensure => "directory",
      owner   => 'deployer',
      group   => 'www-data',
			require => File["/srv/www/${realWebsiteName}"],
    }

		if $disable_robots {
			file { "/srv/www/${realWebsiteName}/$root_path/robots.txt":
				ensure => present,
        owner   => 'deployer',
        group   => 'www-data',
				mode   => 0644,
				path   => "/srv/www/${realWebsiteName}/$root_path/robots.txt",
				source => "puppet:///modules/nl_nginx/global/robots.txt",
				require => File["/srv/www/${realWebsiteName}/$root_path"],
			}
		}

	}

	user { 'www-data':
		ensure => 'present',
		gid    => '33',
		shell  => '/bin/false',
		uid    => '33',
	}

	group { 'www-data':
		ensure => 'present',
		gid    => '33',
	}

	file { "/etc/nginx":
		ensure => "directory",
		owner => "root",
		group => "root",
	}

	file { "/etc/nginx/conf.d":
		ensure  => "directory",
		owner   => "root",
		group   => "root",
		require => File["/etc/nginx"],
	}

	file { "/etc/nginx/conf.d/default.conf":
		ensure => present,
		owner  => "root",
		group  => "root",
		mode   => 0644,
		path   => "/etc/nginx/conf.d/default.conf",
		source => "puppet:///modules/nl_nginx/etc/nginx/conf.d/default.conf",
		require => File["/etc/nginx/conf.d"],
	}

	file { "/etc/nginx/conf.d/types.conf":
		ensure => present,
		owner  => "root",
		group  => "root",
		mode   => 0644,
		path   => "/etc/nginx/conf.d/types.conf",
		source => "puppet:///modules/nl_nginx/etc/nginx/conf.d/types.conf",
		require => File["/etc/nginx/conf.d"],
	}

	file { "/etc/nginx/nginx.conf":
		ensure => present,
		owner  => "root",
		group  => "root",
		mode   => 0644,
		path   => "/etc/nginx/nginx.conf",
		content => template("nl_nginx/etc/nginx/nginx.conf.erb"),
		require => File["/etc/nginx"],
	}

	file { "/etc/nginx/proxy_params":
		ensure => present,
		owner  => "root",
		group  => "root",
		mode   => 0644,
		path   => "/etc/nginx/proxy_params",
		source => "puppet:///modules/nl_nginx/etc/nginx/proxy_params",
		require => File["/etc/nginx"],
	}

	file { "/etc/nginx/sites-available":
		ensure  => "directory",
		owner   => "root",
		group   => "root",
		require => File["/etc/nginx"],
	}

	file { "/etc/nginx/sites-available/default":
		ensure => present,
		owner  => "root",
		group  => "root",
		mode   => 0644,
		path   => "/etc/nginx/sites-available/default",
		source => "puppet:///modules/nl_nginx/etc/nginx/sites-available/default",
		require => File["/etc/nginx/sites-available"],
	}

	file { "/etc/nginx/sites-enabled":
		ensure  => "directory",
		owner   => "root",
		group   => "root",
		require => File["/etc/nginx"],
	}

	# Since nginx is running as www-data, var files must allow for writing for 
	# www-data
	file { "/var/lib/nginx/":
		ensure  => 'directory',
		owner   => 'www-data',
		group   => 'www-data',
		require => [
			Package['www-servers/nginx']
		]
	}

	package { "www-servers/nginx":
		ensure => installed,
	}

	service { 'nginx':
		ensure => running,
		enable => true,
		subscribe => File['/etc/nginx/nginx.conf'],
		require   => [
			File['/etc/nginx/nginx.conf'],
			Package["www-servers/nginx"],
		],
	}

}
