class vcs(
  $vcs_type = '',
) {

  if $vcs_type == "server" {

    file { "/srv/fossil/cgi-bin":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      recurse => true,
      require => File['/srv/fossil'],
    }

    file { "/srv/fossil/cgi-bin/index.cgi":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/fossil/cgi-bin/index.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/index.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/cgi-bin/opml.cgi":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/srv/fossil/cgi-bin/opml.cgi",
      source => "puppet:///files/vcs/srv/fossil/cgi-bin/opml.cgi",
      require => File['/srv/fossil/cgi-bin'],
    }

    file { "/srv/fossil/cgi-bin/list.cgi":
      ensure => present,
      owner => "root",
      group => "root",
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

    # FOSSIL

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

    # CGIT

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

    file { "/etc/nitelite/vcs.d":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite'],
    }

    file { "/etc/cron.daily/fossil_to_git_sync":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/etc/cron.daily/fossil_to_git_sync",
      source => "puppet:///files/vcs/etc/cron.daily/fossil_to_git_sync",
      require => File["/etc/cron.daily"],
    }

    file { "/etc/cron.daily/git_push":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/etc/cron.daily/git_push",
      source => "puppet:///files/vcs/etc/cron.daily/git_push",
      require => File["/etc/cron.daily"],
    }

    file { "/usr/local/bin/fossil-cli":
      ensure => present,
      owner  => "root",
      group  => "root",
      mode   => 0755,
      path   => "/usr/local/bin/fossil-cli",
      source => "puppet:///files/vcs/usr/local/bin/fossil-cli",
    }

    file { "/etc/nitelite/vcs.d/byronsanchez":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d'],
    }

    file { "/etc/nitelite/vcs.d/chompix":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d'],
    }

    file { "/etc/nitelite/vcs.d/hackbytes":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d'],
    }

    file { "/etc/nitelite/vcs.d/tehpotatoking":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/etc/nitelite/vcs.d'],
    }

    $vcs_source_files_byronsanchez = [
      '/etc/nitelite/vcs.d/byronsanchez/dotfiles',
    ]

    $vcs_source_files_chompix = [
      '/etc/nitelite/vcs.d/chompix/coloring-book-android',
      '/etc/nitelite/vcs.d/chompix/coloring-book-ios',
    ]

    $vcs_source_files_hackbytes = [
      '/etc/nitelite/vcs.d/hackbytes/gentoo-bootmodder',
      '/etc/nitelite/vcs.d/hackbytes/gentoo-overlay-a',
      '/etc/nitelite/vcs.d/hackbytes/gentoo-overlay-b',
      '/etc/nitelite/vcs.d/hackbytes/gentoo-overlay-applications',
      '/etc/nitelite/vcs.d/hackbytes/gentoo-provision',
      '/etc/nitelite/vcs.d/hackbytes/hackbytes.com',
      '/etc/nitelite/vcs.d/hackbytes/nitelite.io',
      '/etc/nitelite/vcs.d/hackbytes/puppet-nitelite',
      '/etc/nitelite/vcs.d/hackbytes/wintersmith-articles-helper',
      '/etc/nitelite/vcs.d/hackbytes/wintersmith-handleize-helper',
      '/etc/nitelite/vcs.d/hackbytes/wintersmith-robotskirt',
      '/etc/nitelite/vcs.d/hackbytes/wintersmith-tag-pages',
    ]

    $vcs_source_files_tehpotatoking = [
      '/etc/nitelite/vcs.d/tehpotatoking/creepypasta-files-android',
      '/etc/nitelite/vcs.d/tehpotatoking/creepypasta-files-ios',
    ]

    # TODO: rewrite the git_push script to read a single config file instead of
    # the way it's currently implemented (multiple config files in different org
    # dirs)

    nl_files { $vcs_source_files_byronsanchez:
      owner    => 'root',
      group    => 'root',
      mode     => 0644,
      requires  => File["/etc/nitelite/vcs.d/byronsanchez"],
      source => 'vcs',
    }

    nl_files { $vcs_source_files_chompix:
      owner    => 'root',
      group    => 'root',
      mode     => 0644,
      requires  => File["/etc/nitelite/vcs.d/chompix"],
      source => 'vcs',
    }

    nl_files { $vcs_source_files_hackbytes:
      owner    => 'root',
      group    => 'root',
      mode     => 0644,
      requires  => File["/etc/nitelite/vcs.d/hackbytes"],
      source => 'vcs',
    }

    nl_files { $vcs_source_files_tehpotatoking:
      owner    => 'root',
      group    => 'root',
      mode     => 0644,
      requires  => File["/etc/nitelite/vcs.d/tehpotatoking"],
      source => 'vcs',
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
      source  => "puppet:///files/vcs/etc/xinetd.d/fossil",
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

    file { "/var/lib/nitelite/vcs/repositories":
      ensure => directory,
      owner => "root",
      group => "root",
      require => File['/var/lib/nitelite/vcs'],
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

    $server_packages = [
      'uwsgi',
      'cgit'
    ]

    package { $server_packages: ensure => installed }

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

    exec { "webapp_config_cgit":
      command => "/usr/sbin/webapp-config -I -h cgit.${internal_domain} -d cgit cgit 0.10",
      creates => "/srv/www/cgit.${internal_domain}/htdocs/cgit",
      require => [
        Package[cgit],
        File['/srv/www'],
        File['/etc/vhosts/webapp-config'],
      ]
    }

    nl_nginx::website { "cgit":
      websiteName     => "cgit.internal.nitelite.io",
      environmentName => "production",
      feed_path       => "cgit",
      root_path       => "/htdocs/cgit",
      port            => "8081",
      enable_custom_configs => true,
      enable_cgi      => true,
      cgi_server      => "cgit.internal.nitelite.io:3129",
    }

    file { "/etc/nginx/conf.d/nitelite/cgit.internal.nitelite.io":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/cgit.internal.nitelite.io",
      source => "puppet:///files/vcs/etc/nginx/conf.d/nitelite/cgit.internal.nitelite.io",
    }

    # TODO: consider removing gitbucket in favor of cgit
    #exec { "download_gitbucket":
    #  command => "/usr/bin/wget -P /var/lib/tomcat-7/webapps 
    #  http://binhost.internal.nitelite.io/external/distfiles/gitbucket-1.13.war 
    #  -O gitbucket.war",
    #  creates => "/var/lib/tomcat-7/webapps/gitbucket.war"
    #}

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

  package { $packages: ensure => installed }

}
