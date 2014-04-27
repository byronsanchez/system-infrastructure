# TODO: make type be able to be multiple so that it can be pattern-specific as
# opposed to node-specific
class security($iptables_type) {

  file { "/etc/chkrootkit.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/chkrootkit.conf",
    source => "puppet:///files/security/etc/chkrootkit.conf",
  }

  file { "/etc/rkhunter.conf.local":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/rkhunter.conf.local",
    source => "puppet:///files/security/etc/rkhunter.conf.local",
  }

  file { "/var/lib/iptables":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/var/lib/iptables/rules-save":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0600,
    path    => "/var/lib/iptables/rules-save",
    content => template("security/var/lib/iptables/rules-save.erb"),
    require => File["/var/lib/iptables"],
  }

  file { "/var/lib/ip6tables":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/var/lib/ip6tables/rules-save":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0600,
    path   => "/var/lib/ip6tables/rules-save",
    content => template("security/var/lib/ip6tables/rules-save.erb"),
    require => File["/var/lib/ip6tables"],
  }

  file { "/etc/fail2ban":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/fail2ban/fail2ban.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/fail2ban.conf",
    source  => "puppet:///files/security/etc/fail2ban/fail2ban.conf",
    require => File['/etc/fail2ban'],
  }

  file { "/etc/fail2ban/jail.local":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/jail.local",
    source  => "puppet:///files/security/etc/fail2ban/jail.local",
    require => File['/etc/fail2ban'],
  }

  file { "/etc/fail2ban/action.d":
    ensure => "directory",
    owner => "root",
    group => "root",
    require => File['/etc/fail2ban'],
  }

  file { "/etc/fail2ban/action.d/iptables-multiport-log.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/action.d/iptables-multiport-log.conf",
    source  => "puppet:///files/security/etc/fail2ban/action.d/iptables-multiport-log.conf",
    require => File['/etc/fail2ban/action.d'],
  }

  file { "/etc/fail2ban/action.d/iptables-multiport.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/action.d/iptables-multiport.conf",
    source  => "puppet:///files/security/etc/fail2ban/action.d/iptables-multiport.conf",
    require => File['/etc/fail2ban/action.d'],
  }

  file { "/etc/fail2ban/filter.d":
    ensure => "directory",
    owner => "root",
    group => "root",
    require => File['/etc/fail2ban'],
  }

  file { "/etc/fail2ban/filter.d/apache-badbots.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/apache-badbots.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/apache-badbots.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/nginx-http-auth.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/nginx-http-auth.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/nginx-http-auth.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/nginx-login.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/nginx-login.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/nginx-login.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/nginx-noscript.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/nginx-noscript.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/nginx-noscript.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/nginx-proxy.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/nginx-proxy.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/nginx-proxy.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/pam-generic.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/pam-generic.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/pam-generic.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/sshd-ddos.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/sshd-ddos.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/sshd-ddos.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/sshd.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/sshd.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/sshd.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/fail2ban/filter.d/xinetd-fail.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/fail2ban/filter.d/xinetd-fail.conf",
    source  => "puppet:///files/security/etc/fail2ban/filter.d/xinetd-fail.conf",
    require => File['/etc/fail2ban/filter.d'],
  }

  file { "/etc/portage/package.use/rkhunter":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/rkhunter",
    source => "puppet:///files/security/etc/portage/package.use/rkhunter",
  }

  file { "/etc/portage/package.use/selinux":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/selinux",
    source => "puppet:///files/security/etc/portage/package.use/selinux",
  }

  $packages = [
    "chkrootkit",
    "rkhunter",
    "fail2ban",
    "iptables",
  ]

  package { $packages: ensure => installed }

  service { 'fail2ban':
    ensure => running,
    enable => true,
    subscribe => File['/etc/fail2ban/fail2ban.conf'],
    require   => [
      File['/etc/fail2ban/fail2ban.conf'],
      Package[fail2ban],
    ],
  }

  service { 'ip6tables':
    ensure => running,
    enable => true,
    subscribe => File['/var/lib/ip6tables/rules-save'],
    require   => [
      File['/var/lib/ip6tables/rules-save'],
      Package[iptables],
    ],
  }

  service { 'iptables':
    ensure => running,
    enable => true,
    subscribe => File['/var/lib/iptables/rules-save'],
    require   => [
      File['/var/lib/iptables/rules-save'],
      Package[iptables],
    ],
  }

}
