# server - the authoritative vcs server. local subnet access only
# mirror - a host mirroring the repos. internet accessible
# client - just installs client apps
class vcs(
  $vcs_type = '',
  $mirror_environment = '',
) {

  if $vcs_type == "server" {

    file { "/etc/nitelite/vcs.d":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite'],
    }

    file { "/etc/nitelite/vcs.d/git/byronsanchez":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d/git'],
    }

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

    nl_files { $git_mirror_configs_byronsanchez:
      owner    => 'www-data',
      group    => 'www-data',
      mode     => 0644,
      requires  => File["/etc/nitelite/vcs.d/git/byronsanchez"],
      source => 'vcs',
    }

    # I don't use these rsa keys because I'm not gonna have an exposed internet facing node's root user pushing out to
    # other servers. This was used for my own internal network computer which is a pattern I don't use anymore
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

    # git.hackbytes.com

    exec { "webapp_config_git_${environment}":
      command => "/usr/sbin/webapp-config -I -h git.hackbytes.com -d git cgit 0.10",
      creates => "/srv/www/git.hackbytes.com/htdocs/cgit",
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
        websiteName     => "git.hackbytes.com",
        environmentName => "${mirror_environment}",
        feed_path       => "git",
        root_path       => "/htdocs",
        enable_ssl      => true,
        ssl_cert_path   => "/etc/ssl/hackbytes.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/hackbytes.com/private/cakey.pem.unencrypted",
        enable_custom_configs => true,
        enable_cgi      => true,
        cgi_server      => "cgit.internal.nitelite.io:3129",
      }

      # fossil mirror frontend nginx for https (backend http not needed since the
      # fossil server and the http server are hosted on the same node)
      nl_nginx::website { "fossil":
        websiteName     => "fossil.hackbytes.com",
        environmentName => "${mirror_environment}",
        feed_path       => "fossil",
        root_path       => "/htdocs",
        enable_custom_configs => true,
        enable_ssl      => true,
        enable_cgi      => true,
        # cgi scripts sent here
        cgi_server      => "fossil.hackbytes.com:3128",
        ssl_cert_path   => "/etc/ssl/hackbytes.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/hackbytes.com/private/cakey.pem.unencrypted",
        proxy_pass      => "http://fossilserver",
        proxy_redirect  => "http://fossil.hackbytes.com:4545/ https://fossil.hackbytes.com/",
        upstream        => "fossilserver",
        # non-cgi scripts will be handled by the fossil server
        upstream_server => "fossil.hackbytes.com:4545",
      }

    }
    else {

      # cgit mirror frontend nginx for https (backend http not needed since the cgit
      # server and the http server are hosted on the same node)
      nl_nginx::website { "git":
        websiteName     => "git.hackbytes.com",
        environmentName => "${mirror_environment}",
        feed_path       => "git",
        root_path       => "/htdocs",
        enable_ssl      => true,
        ssl_cert_path   => "/etc/ssl/hackbytes.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/hackbytes.com/private/cakey.pem.unencrypted",
        enable_custom_configs => true,
        enable_cgi      => true,
        cgi_server      => "cgit.internal.nitelite.io:3129",
      }



      # fossil mirror frontend nginx for https (backend http not needed since the
      # fossil server and the http server are hosted on the same node)
      nl_nginx::website { "fossil":
        websiteName     => "fossil.hackbytes.com",
        environmentName => "${mirror_environment}",
        feed_path       => "fossil",
        root_path       => "/htdocs",
        enable_custom_configs => true,
        enable_ssl      => true,
        enable_cgi      => true,
        # cgi scripts sent here
        cgi_server      => "${mirror_environment}.fossil.hackbytes.com:3128",
        ssl_cert_path   => "/etc/ssl/hackbytes.com/cacert.pem",
        ssl_key_path    => "/etc/ssl/hackbytes.com/private/cakey.pem.unencrypted",
        proxy_pass      => "http://fossilserver",
        proxy_redirect  => "http://${mirror_environment}.fossil.hackbytes.com:4545/ https://${mirror_environment}.fossil.hackbytes.com/",
        upstream        => "fossilserver",
        # non-cgi scripts will be handled by the fossil server
        upstream_server => "${mirror_environment}.fossil.hackbytes.com:4545",
      }

    }

    # the front end server
    file { "/etc/nginx/conf.d/nitelite/fossil.hackbytes.com":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/fossil.hackbytes.com",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/fossil.hackbytes.com",
    }

    # needs to be on the cgi server
    file { "/etc/nginx/conf.d/nitelite/git.hackbytes.com":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/git.hackbytes.com",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/git.hackbytes.com",
    }

  }

  # "mirror" and "server" were used to distinguish between two vcs nodes in my
  # old network architecture- an internal "server" on my actual local network
  # not exposed to the internet, and a "mirror" on a remote network that was
  # exposed to the internet.
  #
  # The "server" would regularly push to the "mirror" via cron jobs. It required
  # repo passwords, which is why the server has access to them via 600'd /etc
  # files.
  #
  # I've since stopped using that architecture and am moving to a more typical
  # single workstation on the local network and a single remote node. So I will
  # just push whenever I want to the remote node, which can be considered
  # authoritative, much like a more typical github or bitbucket repo.
  #
  # I can remove the above configs for "server" and "mirror" whenever I wish
  # once I get my new environment configured.
  if ($vcs_type == 'remote') {

    # git.nitelite.io

    exec { "webapp_config_git_${environment}":
      command => "/usr/sbin/webapp-config -I cgit 0.12 -h git.nitelite.io -d git",
      creates => "/srv/www/git.nitelite.io/htdocs/git",
      require => [
        Package[cgit],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

    # cgit internal backend nginx for https
    nl_nginx::website { "git":
      websiteName           => "git.nitelite.io",
      environmentName       => "production",
      feed_path             => "git",
      root_path             => "/htdocs/git",
      enable_custom_configs => true,
      enable_cgi            => true,
      enable_ssl            => true,
      disable_robots        => true,
      cgi_server            => "45.79.190.253:3129",
      ssl_cert_path         => "/etc/letsencrypt/live/git.nitelite.io/fullchain.pem",
      ssl_key_path          => "/etc/letsencrypt/live/git.nitelite.io/privkey.pem",
    }

    # fossil mirror frontend nginx for https (backend http not needed since the
    # fossil server and the http server are hosted on the same node)
    nl_nginx::website { "fossil":
      websiteName           => "fossil.nitelite.io",
      environmentName       => "production",
      feed_path             => "fossil",
      root_path             => "/htdocs",
      enable_custom_configs => true,
      enable_cgi            => true,
      enable_ssl            => true,
      disable_robots        => true,
      ssl_cert_path         => "/etc/letsencrypt/live/fossil.nitelite.io/fullchain.pem",
      ssl_key_path          => "/etc/letsencrypt/live/fossil.nitelite.io/privkey.pem",
      # cgi scripts sent here
      cgi_server      => "45.79.190.253:3128",
      proxy_pass      => "http://fossilserver",
      proxy_redirect  => "http://fossil.nitelite.io:4545/ https://fossil.nitelite.io/",
      upstream        => "fossilserver",
      # non-cgi scripts will be handled by the fossil server
      upstream_server => "localhost:4545",
    }

    # the front end server
    file { "/etc/nginx/conf.d/nitelite/fossil.nitelite.io":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/fossil.nitelite.io",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/fossil.nitelite.io",
    }

    # needs to be on the cgi server
    file { "/etc/nginx/conf.d/nitelite/git.nitelite.io":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/git.nitelite.io",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/git.nitelite.io",
    }

  }

  if ($vcs_type == "server") or ($vcs_type == "mirror") or ($vcs_type == "remote") {

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

    file { "/srv/fossil/configs/project.conf":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/fossil/configs/project.conf",
      source => "puppet:///files/vcs/srv/fossil/configs/project.conf",
      require => File['/srv/fossil/configs'],
    }

    file { "/srv/fossil/configs/skin.conf":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/fossil/configs/skin.conf",
      source => "puppet:///files/vcs/srv/fossil/configs/skin.conf",
      require => File['/srv/fossil/configs'],
    }

    file { "/srv/fossil/fossils":
      ensure => directory,
      owner => "deployer",
      group => "www-data",
      recurse => true,
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
      owner => "deployer",
      group => "www-data",
      recurse => true,
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
      owner => "deployer",
      group => "www-data",
      recurse => true,
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
