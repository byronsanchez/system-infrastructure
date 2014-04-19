class base ($hostname = '', $network_interface = 'eth0') {


  if $hostname {
    # set hostname
    hostname { $hostname:
      node_name => "${hostname}",
    }
    # add host data in hosts files
    class { "hosts":
      node_name => "${hostname}"
    }
  }

  class { "::ntp": }

  file { "/etc/sysctl.conf":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/sysctl.conf",
    content => template("base/etc/sysctl.conf.erb"),
  }

  file { "/etc/resolv.conf":
    ensure => present,
    mode => 0644,
    owner => "root",
    group => "root",
    content => template("base/etc/resolv.conf.erb"),
  }

  file { "/etc/conf.d/keymaps":
    ensure => present,
    mode => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/base/etc/conf.d/keymaps",
  }

  file { "/etc/conf.d/net":
    ensure => present,
    mode => 0644,
    owner => "root",
    group => "root",
    content => template("base/etc/conf.d/net.erb"),
  }

  file { "/etc/crontab":
    ensure => present,
    mode    => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/base/etc/crontab",
  }

  file { "/etc/cron.hourly":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 0750,
  }

  file { "/etc/cron.daily":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 0750,
  }

  file { "/etc/cron.weekly":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 0750,
  }

  file { "/etc/cron.monthly":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 0750,
  }

  file { "/etc/nitelite":
    ensure => "directory",
    owner   => "root",
    group   => "root",
  }

  file { "/etc/portage/package.use/git":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/git",
    source => "puppet:///files/base/etc/portage/package.use/git",
  }

  file { "/etc/portage/package.use/vim":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/vim",
    source => "puppet:///files/base/etc/portage/package.use/vim",
  }

  file { "/etc/profile.d":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/profile.d/ids.custom.sh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/profile.d'],
    path => "/etc/profile.d/ids.custom.sh",
    source => "puppet:///files/base/etc/profile.d/ids.custom.sh",
  }

  file { "/etc/timezone":
    ensure => present,
    mode    => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/base/etc/timezone",
  }

  file { "/etc/ssh/sshd_config":
    ensure => present,
    notify => Service["sshd"],
    mode => 0600,
    owner => "root",
    group => "root",
    source => "puppet:///files/base/etc/ssh/sshd_config",
  }

  file { "/srv":
    ensure => "directory",
    owner  => "root",
    group  => "root",
  }

  file { "/etc/portage/package.use/puppet":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/puppet",
    source => "puppet:///files/base/etc/portage/package.use/puppet",
  }

  file { "/etc/puppet/puppet.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    path => "/etc/puppet/puppet.conf",
    source => "puppet:///files/base/etc/puppet/puppet.conf",
  }

  file { "/etc/portage/package.use/fortune-mod":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/fortune-mod",
    source => "puppet:///files/base/etc/portage/package.use/fortune-mod",
  }

  file { "/etc/profile.d/fortune.custom.sh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/profile.d'],
    path => "/etc/profile.d/fortune.custom.sh",
    source => "puppet:///files/base/etc/profile.d/fortune.custom.sh",
  }

  file { "/etc/screenrc":
    ensure => absent,
    owner => "root",
    group => "root",
    path => "/etc/screenrc",
    source => "puppet:///files/base/opt/screen/etc/screenrc",
  }

  $packages = [
    "puppet",
    "git",
    "rsync",
    "openssh",
    "linux-firmware",
    "dhcpcd",
    "lvm2",
    "syslog-ng",
    "logrotate",
    "vim",
    "pciutils",
    "acpid",
    "gpm",
    "vixie-cron",
    "ruby",
    "python",
    "app-text/tree",
    "sudo",
    "htop",
    "curl",
    "unrar",
    "ca-certificates",
    "netkit-telnetd",
    "tcpdump",
    "strace",
    "cowsay",
    "fortune-mod",
    "zsh",
    "zsh-completion",
  ]

  package {
    $packages: ensure => installed,
  }

  eselect { 'ruby':
    set => 'ruby20',
  }

  $ruby_gems = [
    "bundler",
    "librarian-puppet",
  ]

  package { $ruby_gems:
    ensure  => installed,
    provider => 'gem',
    require => [
      Eselect[ruby],
    ],
  }

  exec { "gem-update":
    command     => "/usr/bin/gem update",
    subscribe   => Package[bundler],
    refreshonly => true,
    require => Eselect[ruby],
  }

  # If the node is a hypervisor, enable the bridge interface. Otherwise, enable
  # the normal network interface. network_interface contains the actual
  # interface name, not the bridge name which is why this conditional is
  # necessary.
  if $network_type == "hypervisor" {
    # Dependency for net info
    service { "net.br0":
      ensure => running,
      enable => true,
    }
  }
  else {
    # Dependency for net info
    service { "net.${network_interface}":
      ensure => running,
      enable => true,
    }
  }

  service { sshd:
    ensure    => running,
    enable => true,
    subscribe => File['/etc/ssh/sshd_config'],
    require   => [
      File['/etc/ssh/sshd_config'],
      Package[openssh],
    ],
  }

  service { 'vixie-cron':
    ensure  => running,
    enable  => true,
    require => [
      Package[vixie-cron],
    ],
  }

  service { 'puppet':
    ensure => 'stopped',
    enable => 'false',
    subscribe => File['/etc/puppet/puppet.conf'],
    require => [
      Package[puppet],
      File['/etc/puppet/puppet.conf']
    ],
  }

  service { 'puppetmaster':
    ensure  => 'stopped',
    enable  => 'false',
    subscribe => File['/etc/puppet/puppet.conf'],
    require => [
      Package[puppet],
      File['/etc/puppet/puppet.conf']
    ],
  }

  exec { "sysctl_update":
    command => "/sbin/sysctl --system",
    subscribe   => File['/etc/sysctl.conf'],
    refreshonly => true,
  }

  # TODO: Have other overlay packages dep on the overlay being set properly
  #package { "app-misc/screen":
  #  ensure  => installed,
  #  require => [
  #    Layman[niteLite],
  #    File['/etc/portage/package.accept_keywords/screen']
  #  ],
  #}

}
