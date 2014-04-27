class mail {

  file { "/etc/cron.daily/mirror_mail":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/cron.daily/mirror_mail",
    source => "puppet:///files/mail/etc/cron.daily/mirror_mail",
    require => File["/etc/cron.daily"],
  }

  file { "/etc/portage/package.use/mutt":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/mutt",
    source => "puppet:///files/mail/etc/portage/package.use/mutt",
  }

  $packages = [
  ]

  package { $packages:
    ensure  => installed,
    require => File['/etc/portage/package.use/mutt'],

  }

}

