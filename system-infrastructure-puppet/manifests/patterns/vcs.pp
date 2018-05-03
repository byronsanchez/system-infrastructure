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
      # nl_nginx::website { "fossil":
      #   websiteName     => "fossil.hackbytes.com",
      #   environmentName => "${mirror_environment}",
      #   feed_path       => "fossil",
      #   root_path       => "/htdocs",
      #   enable_custom_configs => true,
      #   enable_ssl      => true,
      #   enable_cgi      => true,
      #   # cgi scripts sent here
      #   cgi_server      => "fossil.hackbytes.com:3128",
      #   ssl_cert_path   => "/etc/ssl/hackbytes.com/cacert.pem",
      #   ssl_key_path    => "/etc/ssl/hackbytes.com/private/cakey.pem.unencrypted",
      #   proxy_pass      => "http://fossilserver",
      #   proxy_redirect  => "http://fossil.hackbytes.com:4545/ https://fossil.hackbytes.com/",
      #   upstream        => "fossilserver",
      #   # non-cgi scripts will be handled by the fossil server
      #   upstream_server => "fossil.hackbytes.com:4545",
      # }

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
      # nl_nginx::website { "fossil":
      #   websiteName     => "fossil.hackbytes.com",
      #   environmentName => "${mirror_environment}",
      #   feed_path       => "fossil",
      #   root_path       => "/htdocs",
      #   enable_custom_configs => true,
      #   enable_ssl      => true,
      #   enable_cgi      => true,
      #   # cgi scripts sent here
      #   cgi_server      => "${mirror_environment}.fossil.hackbytes.com:3128",
      #   ssl_cert_path   => "/etc/ssl/hackbytes.com/cacert.pem",
      #   ssl_key_path    => "/etc/ssl/hackbytes.com/private/cakey.pem.unencrypted",
      #   proxy_pass      => "http://fossilserver",
      #   proxy_redirect  => "http://${mirror_environment}.fossil.hackbytes.com:4545/ https://${mirror_environment}.fossil.hackbytes.com/",
      #   upstream        => "fossilserver",
      #   # non-cgi scripts will be handled by the fossil server
      #   upstream_server => "${mirror_environment}.fossil.hackbytes.com:4545",
      # }

    }

    # the front end server
    # file { "/etc/nginx/conf.d/nitelite/fossil.hackbytes.com":
    #   ensure => present,
    #   owner => "root",
    #   group => "root",
    #   require => File['/etc/nginx/conf.d/nitelite'],
    #   path => "/etc/nginx/conf.d/nitelite/fossil.hackbytes.com",
    #   source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/fossil.hackbytes.com",
    # }

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

    # git.hackbytes.io

    exec { "webapp_config_git_${environment}":
      command => "/usr/sbin/webapp-config -I cgit 0.12 -h git.hackbytes.io -d git",
      creates => "/srv/www/git.hackbytes.io/htdocs/git",
      require => [
        Package[cgit],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

    file { "/srv/www/git.hackbytes.io/htdocs/git/cgit.css":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/srv/www/git.hackbytes.io/htdocs/git/cgit.css",
      source => "puppet:///files/vcs/srv/www/git.hackbytes.io/htdocs/git/cgit.css",
      require => Exec["webapp_config_git_${environment}"],
    }

    file { "/srv/www/git.hackbytes.io/htdocs/git/style.css":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/srv/www/git.hackbytes.io/htdocs/git/style.css",
      source => "puppet:///files/vcs/srv/www/git.hackbytes.io/htdocs/git/style.css",
      require => Exec["webapp_config_git_${environment}"],
    }

    file { "/srv/www/git.hackbytes.io/htdocs/git/logo.png":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/srv/www/git.hackbytes.io/htdocs/git/logo.png",
      source => "puppet:///files/vcs/srv/www/git.hackbytes.io/htdocs/git/logo.png",
      require => Exec["webapp_config_git_${environment}"],
    }

    file { "/srv/www/git.hackbytes.io/htdocs/git/favicon.ico":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/srv/www/git.hackbytes.io/htdocs/git/favicon.ico",
      source => "puppet:///files/vcs/srv/www/git.hackbytes.io/htdocs/git/favicon.ico",
      require => Exec["webapp_config_git_${environment}"],
    }

    file { "/srv/www/git.hackbytes.io/htdocs/git/header.html":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/srv/www/git.hackbytes.io/htdocs/git/header.html",
      source => "puppet:///files/vcs/srv/www/git.hackbytes.io/htdocs/git/header.html",
      require => Exec["webapp_config_git_${environment}"],
    }

    file { "/srv/www/git.hackbytes.io/htdocs/git/head-include.html":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/srv/www/git.hackbytes.io/htdocs/git/head-include.html",
      source => "puppet:///files/vcs/srv/www/git.hackbytes.io/htdocs/git/head-include.html",
      require => Exec["webapp_config_git_${environment}"],
    }

    file { "/srv/www/git.hackbytes.io/htdocs/git/footer.html":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/srv/www/git.hackbytes.io/htdocs/git/footer.html",
      source => "puppet:///files/vcs/srv/www/git.hackbytes.io/htdocs/git/footer.html",
      require => Exec["webapp_config_git_${environment}"],
    }

    # cgit internal backend nginx for https
    nl_nginx::website { "git":
      websiteName           => "git.hackbytes.io",
      environmentName       => "production",
      feed_path             => "git",
      root_path             => "/htdocs/git",
      enable_custom_configs => true,
      enable_cgi            => true,
      enable_ssl            => true,
      disable_robots        => true,
      cgi_server            => "45.79.190.253:3129",
      ssl_cert_path         => "/etc/letsencrypt/live/git.hackbytes.io/fullchain.pem",
      ssl_key_path          => "/etc/letsencrypt/live/git.hackbytes.io/privkey.pem",
    }

    # fossil mirror frontend nginx for https (backend http not needed since the
    # fossil server and the http server are hosted on the same node)
    # nl_nginx::website { "fossil":
    #   websiteName           => "fossil.hackbytes.io",
    #   environmentName       => "production",
    #   feed_path             => "fossil",
    #   root_path             => "/htdocs",
    #   enable_custom_configs => true,
    #   enable_cgi            => true,
    #   enable_ssl            => true,
    #   disable_robots        => true,
    #   ssl_cert_path         => "/etc/letsencrypt/live/fossil.hackbytes.io/fullchain.pem",
    #   ssl_key_path          => "/etc/letsencrypt/live/fossil.hackbytes.io/privkey.pem",
    #   # cgi scripts sent here
    #   cgi_server      => "45.79.190.253:3128",
    #   proxy_pass      => "http://fossilserver",
    #   proxy_redirect  => "http://fossil.hackbytes.io:4545/ https://fossil.hackbytes.io/",
    #   upstream        => "fossilserver",
    #   # non-cgi scripts will be handled by the fossil server
    #   upstream_server => "localhost:4545",
    # }

    # the front end server
    # file { "/etc/nginx/conf.d/nitelite/fossil.hackbytes.io":
    #   ensure => present,
    #   owner => "root",
    #   group => "root",
    #   require => File['/etc/nginx/conf.d/nitelite'],
    #   path => "/etc/nginx/conf.d/nitelite/fossil.hackbytes.io",
    #   source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/fossil.hackbytes.io",
    # }

    # needs to be on the cgi server
    # file { "/etc/nginx/conf.d/nitelite/git.hackbytes.io":
    #   ensure => present,
    #   owner => "root",
    #   group => "root",
    #   require => File['/etc/nginx/conf.d/nitelite'],
    #   path => "/etc/nginx/conf.d/nitelite/git.hackbytes.io",
    #   source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/git.hackbytes.io",
    # }

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
      ensure => absent,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/etc/cron.d/fossil-ping",
      source => "puppet:///files/vcs/etc/cron.d/fossil-ping",
      require => File["/etc/cron.d"],
    }

    file { "/usr/local/bin/fossil-cli":
      ensure => absent,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-cli",
      source => "puppet:///files/vcs/usr/local/bin/fossil-cli",
    }

    file { "/usr/local/bin/fossil-ping":
      ensure => absent,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-ping",
      source => "puppet:///files/vcs/usr/local/bin/fossil-ping",
    }

    file { "/usr/local/bin/fossil-to-git-sync":
      ensure => absent,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-to-git-sync",
      source => "puppet:///files/vcs/usr/local/bin/fossil-to-git-sync",
    }

    file { "/usr/local/bin/fossil-sync":
      ensure => absent,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-sync",
      source => "puppet:///files/vcs/usr/local/bin/fossil-sync",
    }

    file { "/etc/cron.d/git-ping":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0644,
      path   => "/etc/cron.d/git-ping",
      source => "puppet:///files/vcs/etc/cron.d/git-ping",
      require => File["/etc/cron.d"],
    }

    file { "/usr/local/bin/git-ping":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/git-ping",
      source => "puppet:///files/vcs/usr/local/bin/git-ping",
    }

    file { "/usr/local/bin/git-sync":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/git-sync",
      source => "puppet:///files/vcs/usr/local/bin/git-sync",
    }

    file { "/usr/local/bin/create-repo":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/create-repo",
      source => "puppet:///files/vcs/usr/local/bin/create-repo",
    }

    file { "/usr/local/bin/delete-repo":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/delete-repo",
      source => "puppet:///files/vcs/usr/local/bin/delete-repo",
    }

    file { "/usr/local/bin/change-description":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/change-description",
      source => "puppet:///files/vcs/usr/local/bin/change-description",
    }

    file { "/usr/local/bin/list-repos":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/list-repos",
      source => "puppet:///files/vcs/usr/local/bin/list-repos",
    }

    file { "/usr/local/bin/help-me":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/help-me",
      source => "puppet:///files/vcs/usr/local/bin/help-me",
    }

    # TODO: If you end up using these scripts a lot, fix it so that ssh commands
    # have /usr/local/bin in the path.
    #
    # The reason I'm symlinking right now is because these commands don't get
    # added to the ssh command path env.

    file { '/usr/bin/create-repo':
      ensure => 'link',
      target => '/usr/local/bin/create-repo',
      require => File['/usr/local/bin/create-repo'],
    }

    file { '/usr/bin/delete-repo':
      ensure => 'link',
      target => '/usr/local/bin/delete-repo',
      require => File['/usr/local/bin/delete-repo'],
    }

    file { '/usr/bin/change-description':
      ensure => 'link',
      target => '/usr/local/bin/change-description',
      require => File['/usr/local/bin/change-description'],
    }

    file { '/usr/bin/list-repos':
      ensure => 'link',
      target => '/usr/local/bin/list-repos',
      require => File['/usr/local/bin/list-repos'],
    }

    file { '/usr/bin/help-me':
      ensure => 'link',
      target => '/usr/local/bin/help-me',
      require => File['/usr/local/bin/help-me'],
    }



    # FOSSIL

    file { "/srv/fossil/cgi-bin":
      #ensure  => directory,
      ensure => absent,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil/cgi-bin/index.cgi":
      ensure => absent,
      owner => "root",
      group => "root",
      mode    => "0755",
      path => "/srv/fossil/cgi-bin/index.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/index.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/cgi-bin/opml.cgi":
      ensure => absent,
      owner => "root",
      group => "root",
      mode    => "0755",
      path => "/srv/fossil/cgi-bin/opml.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/opml.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/cgi-bin/list.cgi":
      ensure => absent,
      owner => "root",
      group => "root",
      mode    => "0755",
      path => "/srv/fossil/cgi-bin/list.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/list.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/configs":
      #ensure => directory,
      ensure => absent,
      owner => "root",
      group => "root",
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil/configs/project.conf":
      ensure => absent,
      owner => "root",
      group => "root",
      path => "/srv/fossil/configs/project.conf",
      source => "puppet:///files/vcs/srv/fossil/configs/project.conf",
      require => File['/srv/fossil/configs'],
    }

    file { "/srv/fossil/configs/skin.conf":
      ensure => absent,
      owner => "root",
      group => "root",
      path => "/srv/fossil/configs/skin.conf",
      source => "puppet:///files/vcs/srv/fossil/configs/skin.conf",
      require => File['/srv/fossil/configs'],
    }

    file { "/srv/fossil/fossils":
      #ensure => directory,
      ensure => absent,
      owner => "deployer",
      group => "www-data",
      recurse => true,
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil":
      #ensure => directory,
      ensure => absent,
      owner => "root",
      group => "root",
      require => File['/srv'],
    }

    file { "/srv/fossil/uwsgi":
      #ensure => directory,
      ensure => absent,
      owner => "root",
      group => "root",
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil/uwsgi/cgi":
      #ensure => directory,
      ensure => absent,
      owner => "root",
      group => "root",
      require => File['/srv/fossil/uwsgi'],
    }

    file { "/srv/fossil/uwsgi/cgi/config":
      #ensure => directory,
      ensure => absent,
      owner => "root",
      group => "root",
      require => File['/srv/fossil/uwsgi/cgi'],
    }

    file { "/srv/fossil/uwsgi/cgi/config/config.xml":
      ensure => absent,
      owner => "root",
      group => "root",
      path => "/srv/fossil/uwsgi/cgi/config/config.xml",
      content => template("vcs/srv/fossil/uwsgi/cgi/config/config.xml.erb"),
      require => File['/srv/fossil/uwsgi/cgi/config'],
    }

    file { "/etc/conf.d/uwsgi.fossil":
      ensure => absent,
      owner => "root",
      group => "root",
      path => "/etc/conf.d/uwsgi.fossil",
      content => template("vcs/etc/conf.d/uwsgi.fossil.erb"),
    }

    file { '/etc/init.d/uwsgi.fossil':
      #ensure => 'link',
      ensure => 'absent',
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
      ensure  => absent,
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
      ensure    => 'stopped',
      enable => false,
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
    ensure => absent,
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
    # disabling git because it /always/ recompiles on gentoo nodes
    #"git",
    "fossil",
    "mercurial",
    "subversion",
    "bzr",
    "rcs",
  ]

  $packages_require = [
    #File["/etc/portage/package.use/fossil"],
    File["/etc/portage/package.use/git"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

}
