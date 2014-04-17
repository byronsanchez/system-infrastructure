class mirror {

  $websitelist = hiera('websitelist')

  file { "/etc/cron.daily/mirror_tldp":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/cron.daily/mirror_tldp",
    source => "puppet:///files/mirror/etc/cron.daily/mirror_tldp",
    require => File["/etc/cron.daily"],
  }

  file { "/etc/cron.daily/mirror_ietf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/cron.daily/mirror_ietf",
    source => "puppet:///files/mirror/etc/cron.daily/mirror_ietf",
    require => File["/etc/cron.daily"],
  }

  file { "/etc/cron.daily/mirror_git":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/cron.daily/mirror_git",
    source => "puppet:///files/mirror/etc/cron.daily/mirror_git",
    require => File["/etc/cron.daily"],
  }

  file { "/etc/cron.daily/mirror_hg":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/cron.daily/mirror_hg",
    source => "puppet:///files/mirror/etc/cron.daily/mirror_hg",
    require => File["/etc/cron.daily"],
  }

  file { "/etc/cron.daily/mirror_svn":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/cron.daily/mirror_svn",
    source => "puppet:///files/mirror/etc/cron.daily/mirror_svn",
    require => File["/etc/cron.daily"],
  }

  file { "/etc/cron.monthly/mirror_website":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/cron.monthly/mirror_website",
    source => "puppet:///files/mirror/etc/cron.monthly/mirror_website",
    require => File["/etc/cron.monthly"],
  }

  file { "/etc/nitelite/gitlist":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nitelite/gitlist",
    source => "puppet:///files/mirror/etc/nitelite/gitlist",
    require => File["/etc/nitelite"],
  }

  file { "/etc/nitelite/hglist":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nitelite/hglist",
    source => "puppet:///files/mirror/etc/nitelite/hglist",
    require => File["/etc/nitelite"],
  }

  file { "/etc/nitelite/svnlist":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nitelite/svnlist",
    source => "puppet:///files/mirror/etc/nitelite/svnlist",
    require => File["/etc/nitelite"],
  }

  file { "/etc/nitelite/websitelist":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/nitelite/websitelist",
    content => template("mirror/etc/nitelite/websitelist.erb"),
    require => File["/etc/nitelite"],
  }

  $packages = [
    "httrack",
  ]

  package { $packages: ensure => installed }

}
