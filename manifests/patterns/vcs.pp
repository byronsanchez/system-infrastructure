# server - the authoritative vcs server. local subnet access only
# mirror - a host mirroring the repos. internet accessible
# client - just installs client apps
class vcs(
  $vcs_type = '',
  $mirror_environment = '',
) {

  $fossilpw = hiera('fossilpw', '')

  if $vcs_type == "server" {

    file { "/etc/nitelite/vcs.d":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite'],
    }

    file { "/etc/nitelite/vcs.d/fossil":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d'],
    }

    file { "/etc/nitelite/vcs.d/fossil/byronsanchez":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d/fossil'],
    }

    file { "/etc/nitelite/vcs.d/git":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d'],
    }

    file { "/etc/nitelite/vcs.d/git/byronsanchez":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d/git'],
    }

    $fossil_mirror_configs_byronsanchez = [
      '/etc/nitelite/vcs.d/fossil/byronsanchez/dotfiles',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/coloring-book-android',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/coloring-book-ios',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/gentoo-bootmodder',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/gentoo-overlay-a',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/gentoo-overlay-b',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/gentoo-overlay-applications',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/gentoo-provision',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/hackbytes.com',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/system-infrastructure',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/wintersmith-articles-helper',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/wintersmith-handleize-helper',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/wintersmith-robotskirt',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/wintersmith-tag-pages',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/creepypasta-files-android',
      '/etc/nitelite/vcs.d/fossil/byronsanchez/creepypasta-files-ios',
    ]

    $git_mirror_configs_byronsanchez = [
      '/etc/nitelite/vcs.d/git/byronsanchez/dotfiles',
      '/etc/nitelite/vcs.d/git/byronsanchez/coloring-book-android',
      '/etc/nitelite/vcs.d/git/byronsanchez/coloring-book-ios',
      '/etc/nitelite/vcs.d/git/byronsanchez/gentoo-bootmodder',
      '/etc/nitelite/vcs.d/git/byronsanchez/gentoo-overlay-a',
      '/etc/nitelite/vcs.d/git/byronsanchez/gentoo-overlay-b',
      '/etc/nitelite/vcs.d/git/byronsanchez/gentoo-overlay-applications',
      '/etc/nitelite/vcs.d/git/byronsanchez/gentoo-provision',
      '/etc/nitelite/vcs.d/git/byronsanchez/hackbytes.com',
      '/etc/nitelite/vcs.d/git/byronsanchez/system-infrastructure',
      '/etc/nitelite/vcs.d/git/byronsanchez/wintersmith-articles-helper',
      '/etc/nitelite/vcs.d/git/byronsanchez/wintersmith-handleize-helper',
      '/etc/nitelite/vcs.d/git/byronsanchez/wintersmith-robotskirt',
      '/etc/nitelite/vcs.d/git/byronsanchez/wintersmith-tag-pages',
      '/etc/nitelite/vcs.d/git/byronsanchez/creepypasta-files-android',
      '/etc/nitelite/vcs.d/git/byronsanchez/creepypasta-files-ios',
    ]

    # TODO: rewrite the git_push script to read a single config file instead of
    # the way it's currently implemented (multiple config files in different org
    # dirs)

    nl_files { $fossil_mirror_configs_byronsanchez:
      owner     => 'www-data',
      group     => 'www-data',
      mode      => 0600,
      requires  => File["/etc/nitelite/vcs.d/fossil/byronsanchez"],
      source    => 'vcs',
      file_type => 'template',
    }

    nl_files { $git_mirror_configs_byronsanchez:
      owner    => 'www-data',
      group    => 'www-data',
      mode     => 0644,
      requires  => File["/etc/nitelite/vcs.d/git/byronsanchez"],
      source => 'vcs',
    }

    file { "/root/.ssh/vcs_rsa":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0600,
      path => "/root/.ssh/vcs_rsa",
      source => "puppet:///secure/ssh/vcs_rsa",
    }

    file { "/root/.ssh/vcs_rsa.pub":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      path => "/root/.ssh/vcs_rsa.pub",
      source => "puppet:///secure/ssh/vcs_rsa.pub",
    }

    # git.internal.nitelite.io
    # TODO: Make use of the install instead of source path that is currently 
    # used by uwsgi configs

    exec { "webapp_config_cgit":
      command => "/usr/sbin/webapp-config -I -h git.${internal_domain} -d git cgit 0.10",
      creates => "/srv/www/git.${internal_domain}/htdocs/cgit",
      require => [
        Package[cgit],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

    # cgit internal backend nginx for https
    nl_nginx::website { "cgit_internal":
      websiteName     => "cgit.internal.nitelite.io",
      environmentName => "production",
      feed_path       => "git",
      root_path       => "/htdocs/cgit",
      port            => "8081",
      enable_custom_configs => true,
      enable_cgi      => true,
      cgi_server      => "cgit.internal.nitelite.io:3129",
    }

    file { "/etc/nginx/conf.d/nitelite/git.internal.nitelite.io":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/git.internal.nitelite.io",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/git.internal.nitelite.io",
    }

  }

  if ($vcs_type == "mirror") {

    # git.tehpotatoking.com

    exec { "webapp_config_git_${environment}":
      command => "/usr/sbin/webapp-config -I -h git.tehpotatoking.com -d git cgit 0.10",
      creates => "/srv/www/git.tehpotatoking.com/htdocs/cgit",
      require => [
        Package[cgit],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

    if $mirror_environment == "production" {

      # cgit mirror frontend nginx for https (backend http not needed since the cgit
      # server and the http server are hosted on the same node)
      nl_nginx::website { "git":
        websiteName     => "git.tehpotatoking.com",
        environmentName => "${mirror_environment}",
        feed_path       => "git",
        root_path       => "/htdocs",
        enable_ssl      => true,
        ssl_cert_path   => "/etc/ssl/tehpotatoking.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/tehpotatoking.com/private/cakey.pem.unencrypted",
        enable_custom_configs => true,
        enable_cgi      => true,
        cgi_server      => "cgit.internal.nitelite.io:3129",
      }

      # fossil mirror frontend nginx for https (backend http not needed since the
      # fossil server and the http server are hosted on the same node)
      nl_nginx::website { "fossil":
        websiteName     => "fossil.tehpotatoking.com",
        environmentName => "${mirror_environment}",
        feed_path       => "fossil",
        root_path       => "/htdocs",
        enable_custom_configs => true,
        enable_ssl      => true,
        enable_cgi      => true,
        # cgi scripts sent here
        cgi_server      => "fossil.tehpotatoking.com:3128",
        ssl_cert_path   => "/etc/ssl/tehpotatoking.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/tehpotatoking.com/private/cakey.pem.unencrypted",
        proxy_pass      => "http://fossilserver",
        proxy_redirect  => "http://fossil.tehpotatoking.com:4545/ https://fossil.tehpotatoking.com/",
        upstream        => "fossilserver",
        # non-cgi scripts will be handled by the fossil server
        upstream_server => "fossil.tehpotatoking.com:4545",
      }

    }
    else {

      # cgit mirror frontend nginx for https (backend http not needed since the cgit
      # server and the http server are hosted on the same node)
      nl_nginx::website { "git":
        websiteName     => "git.tehpotatoking.com",
        environmentName => "${mirror_environment}",
        feed_path       => "git",
        root_path       => "/htdocs",
        enable_ssl      => true,
        ssl_cert_path   => "/etc/ssl/tehpotatoking.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/tehpotatoking.com/private/cakey.pem.unencrypted",
        enable_custom_configs => true,
        enable_cgi      => true,
        cgi_server      => "cgit.internal.nitelite.io:3129",
      }

      # fossil mirror frontend nginx for https (backend http not needed since the
      # fossil server and the http server are hosted on the same node)
      nl_nginx::website { "fossil":
        websiteName     => "fossil.tehpotatoking.com",
        environmentName => "${mirror_environment}",
        feed_path       => "fossil",
        root_path       => "/htdocs",
        enable_custom_configs => true,
        enable_ssl      => true,
        enable_cgi      => true,
        # cgi scripts sent here
        cgi_server      => "${mirror_environment}.fossil.tehpotatoking.com:3128",
        ssl_cert_path   => "/etc/ssl/tehpotatoking.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/tehpotatoking.com/private/cakey.pem.unencrypted",
        proxy_pass      => "http://fossilserver",
        proxy_redirect  => "http://${mirror_environment}.fossil.tehpotatoking.com:4545/ https://${mirror_environment}.fossil.tehpotatoking.com/",
        upstream        => "fossilserver",
        # non-cgi scripts will be handled by the fossil server
        upstream_server => "${mirror_environment}.fossil.tehpotatoking.com:4545",
      }

    }

    # the front end server
    file { "/etc/nginx/conf.d/nitelite/fossil.tehpotatoking.com":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/fossil.tehpotatoking.com",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/fossil.tehpotatoking.com",
    }

    # needs to be on the cgi server
    file { "/etc/nginx/conf.d/nitelite/git.tehpotatoking.com":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/git.tehpotatoking.com",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/git.tehpotatoking.com",
    }

  }

  if ($vcs_type == "server") or ($vcs_type == "mirror") {

    # needs to be on the cgi server
    file { "/etc/portage/package.accept_keywords/uwsgi":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.accept_keywords'],
      path => "/etc/portage/package.accept_keywords/uwsgi",
      source => "puppet:///files/vcs/etc/portage/package.accept_keywords/uwsgi",
    }

    file { "/etc/cron.d/fossil-ping":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/etc/cron.d/fossil-ping",
      source => "puppet:///files/vcs/etc/cron.d/fossil-ping",
      require => File["/etc/cron.d"],
    }

    file { "/usr/local/bin/fossil-cli":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-cli",
      source => "puppet:///files/vcs/usr/local/bin/fossil-cli",
    }

    file { "/usr/local/bin/fossil-ping":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-ping",
      source => "puppet:///files/vcs/usr/local/bin/fossil-ping",
    }

    file { "/usr/local/bin/fossil-to-git-sync":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-to-git-sync",
      source => "puppet:///files/vcs/usr/local/bin/fossil-to-git-sync",
    }

    file { "/usr/local/bin/fossil-sync":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-sync",
      source => "puppet:///files/vcs/usr/local/bin/fossil-sync",
    }

    file { "/usr/local/bin/git-sync":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/git-sync",
      source => "puppet:///files/vcs/usr/local/bin/git-sync",
    }

    # FOSSIL

    file { "/srv/fossil/cgi-bin":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil/cgi-bin/index.cgi":
      ensure => present,
      owner => "root",
      group => "root",
      mode    => "0755",
      path => "/srv/fossil/cgi-bin/index.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/index.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/cgi-bin/opml.cgi":
      ensure => present,
      owner => "root",
      group => "root",
      mode    => "0755",
      path => "/srv/fossil/cgi-bin/opml.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/opml.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/cgi-bin/list.cgi":
      ensure => present,
      owner => "root",
      group => "root",
      mode    => "0755",
      path => "/srv/fossil/cgi-bin/list.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/list.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/configs":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil/configs/blackwhitealt.txt":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/fossil/configs/blackwhitealt.txt",
      source => "puppet:///files/vcs/srv/fossil/configs/blackwhitealt.txt",
      require => File['/srv/fossil/configs'],
    }

    file { "/srv/fossil/configs/googlecode.txt":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/fossil/configs/googlecode.txt",
      source => "puppet:///files/vcs/srv/fossil/configs/googlecode.txt",
      require => File['/srv/fossil/configs'],
    }

    file { "/srv/fossil/fossils":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv'],
    }

    file { "/srv/fossil/uwsgi":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil/uwsgi/cgi":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/fossil/uwsgi'],
    }

    file { "/srv/fossil/uwsgi/cgi/config":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/fossil/uwsgi/cgi'],
    }

    file { "/srv/fossil/uwsgi/cgi/config/config.xml":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/fossil/uwsgi/cgi/config/config.xml",
      content => template("vcs/srv/fossil/uwsgi/cgi/config/config.xml.erb"),
      require => File['/srv/fossil/uwsgi/cgi/config'],
    }

    file { "/etc/conf.d/uwsgi.fossil":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/etc/conf.d/uwsgi.fossil",
      content => template("vcs/etc/conf.d/uwsgi.fossil.erb"),
    }

    file { '/etc/init.d/uwsgi.fossil':
       ensure => 'link',
       target => '/etc/init.d/uwsgi',
    }

    # GIT

    file { "/srv/git":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv'],
    }

    file { "/srv/git/repositories":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/git'],
    }

    file { "/srv/git/uwsgi":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/git'],
    }

    file { "/srv/git/uwsgi/cgi":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/git/uwsgi'],
    }

    file { "/srv/git/uwsgi/cgi/config":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/srv/git/uwsgi/cgi'],
    }

    file { "/srv/git/uwsgi/cgi/config/config.xml":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/git/uwsgi/cgi/config/config.xml",
      content => template("vcs/srv/git/uwsgi/cgi/config/config.xml.erb"),
      require => File['/srv/git/uwsgi/cgi/config'],
    }

    file { "/etc/cgitrc":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/etc/cgitrc",
      source => "puppet:///files/vcs/etc/cgitrc",
    }

    file { "/etc/conf.d/uwsgi.cgit":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/etc/conf.d/uwsgi.cgit",
      content => template("vcs/etc/conf.d/uwsgi.cgit.erb"),
    }

    file { '/etc/init.d/uwsgi.cgit':
       ensure => 'link',
       target => '/etc/init.d/uwsgi',
    }

    file { "/etc/portage/package.use/uwsgi":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/uwsgi",
      source => "puppet:///files/vcs/etc/portage/package.use/uwsgi",
    }

    file { "/etc/xinetd.d/fossil":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      path    => "/etc/xinetd.d/fossil",
      content => template("vcs/etc/xinetd.d/fossil.erb"),
      require => File["/etc/xinetd.d"],
    }

    file { "/etc/xinetd.d/git":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      path    => "/etc/xinetd.d/git",
      source  => "puppet:///files/vcs/etc/xinetd.d/git",
      require => File["/etc/xinetd.d"],
    }

    file { "/var/lib/nitelite/vcs":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/var/lib/nitelite'],
    }

    $server_packages = [
      'uwsgi',
      'cgit'
    ]

    $server_packages_require = [
      File["/etc/portage/package.accept_keywords/uwsgi"],
      File["/etc/portage/package.use/uwsgi"],
    ]

    package { $server_packages:
      ensure  => installed,
      require => $server_packages_require,
    }

    service { "uwsgi.fossil":
      ensure    => running,
      enable => true,
      subscribe => File['/srv/fossil/uwsgi/cgi/config/config.xml'],
      require   => [
        File['/srv/fossil/uwsgi/cgi/config/config.xml'],
        File['/etc/conf.d/uwsgi.fossil'],
        File['/etc/init.d/uwsgi.fossil'],
        Package[uwsgi],
      ],
    }

    service { "uwsgi.cgit":
      ensure    => running,
      enable => true,
      subscribe => File['/srv/git/uwsgi/cgi/config/config.xml'],
      require   => [
        File['/srv/git/uwsgi/cgi/config/config.xml'],
        File['/etc/conf.d/uwsgi.cgit'],
        File['/etc/init.d/uwsgi.cgit'],
        Package[uwsgi],
      ],
    }

  }

  file { "/etc/portage/package.use/fossil":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/fossil",
    source => "puppet:///files/vcs/etc/portage/package.use/fossil",
  }

  file { "/etc/portage/package.use/git":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/git",
    source => "puppet:///files/vcs/etc/portage/package.use/git",
  }

  $packages = [
    "git",
    "fossil",
    "mercurial",
    "subversion",
    "bzr",
    "rcs",
  ]

  $packages_require = [
    File["/etc/portage/package.use/fossil"],
    File["/etc/portage/package.use/git"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

}
