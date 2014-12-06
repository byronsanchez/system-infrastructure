# hostname = duh
# mcollective_type = client || server
#  - not intuitive at first. servers = nodes to manage, clients = nodes to
#  administer from
#  - think of it this way. servers SERVE node data to clients. Clients are used
#  to actually administer nodes. so most nodes will be servers, and nodes that
#  will be used to administer things are clients. this is why the default is
#  server
class base (
  $environment = 'development',
  $hostname,
  $network_type = '',
  $mcollective_type = 'server',
  $network_interface = 'eth0',
  $enable_docker = false,
) {

  $rabbitmq_mcollective_password = hiera('rabbitmq_mcollective_password', '')

  if $hostname {
    # set hostname
    nl_hostname { $hostname:
      node_name => "${hostname}",
    }
    # add host data in hosts files
    class { "nl_hosts":
      node_name => "${hostname}"
    }
  }

  class { "::ntp": }

  file { "/etc/profile.d/env.custom.sh":
    ensure  => present,
    owner   => "root",
    group   => "root",
    path    => "/etc/profile.d/env.custom.sh",
    content => template('base/etc/profile.d/env.custom.sh.erb'),
  }

  # set the client USE flag on nodes that will be used to administer mco
  # commands
  file { "/etc/portage/package.use/mcollective":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    require => File['/etc/portage/package.use'],
    path    => "/etc/portage/package.use/mcollective",
    content => template("base/etc/portage/package.use/mcollective.erb"),
  }

  file { "/etc/mcollective/facts.yaml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 400,
    path    => "/etc/mcollective/facts.yaml",
    content => template('base/etc/mcollective/facts.yaml.erb'),
  }

  # all nodes are servers, but not all nodes are clients (admins)
  file { "/etc/mcollective/server.cfg":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/mcollective/server.cfg",
    content => template("base/etc/mcollective/server.cfg.erb"),
  }

  # the random number will be >= 0 and less than MAX
  #
  # generate random values that will persist for each node, but be totally
  # different across nodes. these values will change if the fqdn changes
  # Max value is padded to allow for addition to the random number for
  # time seperation between each crontab task
  # minutes needs at least 30 min of padding
  $random_minute = fqdn_rand(30, 'cron') + 0
  # hour needs at least two hours of padding
  $random_hour = fqdn_rand(22, 'cron') + 0
  # day of week will be 6 for all nodes. only difference (between nodes) is which hour
  # and minute
  # day of month will be the first for all nodes. only difference (between
  # nodes) is which hour and minute

  file { "/etc/crontab":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/crontab",
    content => template("base/etc/crontab.erb"),
  }

  if $mcollective_type == "client" {

    file { "/etc/mcollective/client.cfg":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/etc/mcollective/client.cfg",
      content => template("base/etc/mcollective/client.cfg.erb"),
    }

  }

  file { "/etc/sysctl.conf":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/sysctl.conf",
    content => template("base/etc/sysctl.conf.erb"),
  }

  file { "/etc/local.d/00sysctl.start":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/etc/local.d/00sysctl.start",
    source => "puppet:///files/base/etc/local.d/00sysctl.start",
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

  file { "/etc/cron.d":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 0750,
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

  file { "/etc/portage/package.use/cairo":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/cairo",
    source => "puppet:///files/base/etc/portage/package.use/cairo",
  }

  file { "/etc/portage/package.use/vim":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/vim",
    source => "puppet:///files/base/etc/portage/package.use/vim",
  }

  file { "/etc/portage/package.use/mutt":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/mutt",
    source => "puppet:///files/base/etc/portage/package.use/mutt",
  }

  file { "/etc/portage/package.use/python":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/python",
    source => "puppet:///files/base/etc/portage/package.use/python",
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

  file { "/etc/services":
    ensure => present,
    mode    => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/base/etc/services",
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

  file { "/etc/profile.d/fortune.custom.sh":
    ensure => absent,
    owner => "root",
    group => "root",
    require => File['/etc/profile.d'],
    path => "/etc/profile.d/fortune.custom.sh",
    source => "puppet:///files/base/etc/profile.d/fortune.custom.sh",
  }

  file { "/usr/local/lib/nitelite":
    ensure => "directory",
    owner  => "root",
    group  => "root",
  }

  file { "/usr/local/lib/nitelite/helpers":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    require => File['/usr/local/lib/nitelite'],
  }

  file { "/usr/local/lib/nitelite/helpers/common.lib.sh":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/usr/local/lib/nitelite/helpers'],
    path => "/usr/local/lib/nitelite/helpers/common.lib.sh",
    source => "puppet:///files/base/usr/local/lib/nitelite/helpers/common.lib.sh",
  }

  file { "/usr/local/bin/update-node":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/update-node",
    source => "puppet:///files/base/usr/local/bin/update-node",
  }

  file { "/etc/screenrc":
    ensure => absent,
    owner => "root",
    group => "root",
    path => "/etc/screenrc",
    source => "puppet:///files/base/opt/screen/etc/screenrc",
  }

  file { "/var/lib/nitelite":
    ensure => "directory",
    owner   => "root",
    group   => "root",
  }

  $packages = [
    "the_silver_searcher",
    "rsync",
    "openssh",
    "linux-firmware",
    "dhcpcd",
    "lvm2",
    "vim",
    "pciutils",
    "usbutils",
    "acpid",
    "gpm",
    "vixie-cron",
    "ruby",
    "python",
    "app-text/tree",
    "sudo",
    "htop",
    "iotop",
    "curl",
    "unrar",
    "mutt",
    "netkit-telnetd",
    "p7zip",
    "pigz",
    "pv",
    "tcpdump",
    "strace",
    "traceroute",
  ]

  package {
    $packages: ensure => installed,
  }

  # Ensure ruby 1.9 is set prior to installing these via portage
  $ruby_packages = [
    "puppet",
    "stomp",
    "mcollective",
  ]

  package { $ruby_packages:
    ensure  => installed,
    require => [
      Eselect[ruby],
    ],
  }

  # System ruby HAS to be 1.9 for mcollective to work. If other rubies are
  # needed, find an alternative solution to deploy them.
  eselect { 'ruby':
    set => 'ruby19',
  }

  $ruby_gems = [
    "bundler",
    "rdoc",
    "librarian-puppet",
    "hiera-eyaml",
  ]

  package { $ruby_gems:
    ensure  => installed,
    provider => 'gem',
    require => [
      Eselect[ruby],
    ],
  }

  $mcollective_packages = [
    "mcollective-filemgr-agent",
    "mcollective-package-agent",
    "mcollective-process-agent",
    "mcollective-puppet-agent",
    "mcollective-service-agent",
  ]

  package { $mcollective_packages:
    ensure  => installed,
  }

  exec { "gem-update":
    command     => "/usr/bin/gem update",
    subscribe   => Package[bundler],
    refreshonly => true,
    require => Eselect[ruby],
  }

  # If the node is a hypervisor or vpn, enable the bridge interface. Otherwise, enable
  # the normal network interface. network_interface contains the actual
  # interface name, not the bridge name which is why this conditional is
  # necessary.
  # TODO: Consider adding symlinks to the network interface that is setup during provisioningg (eg. eth0)
  if $network_type == "hypervisor" {
    # Dependency for net info
    service { "/etc/init.d/net.br0":
      ensure => running,
      enable => true,
      require => File['/etc/init.d/net.br0'],
    }

    file { '/etc/init.d/net.br0':
       ensure => 'link',
       target => '/etc/init.d/net.lo',
    }
  }
  elsif $network_type == "vpn" {

    service { "net.br0":
      ensure => running,
      enable => true,
      require => File['/etc/init.d/net.br0'],
    }

    file { '/etc/init.d/net.br0':
       ensure => 'link',
       target => '/etc/init.d/net.lo',
    }

    file { '/etc/init.d/net.tap0':
       ensure => 'link',
       target => '/etc/init.d/net.lo',
    }

  }
  else {
    # Dependency for net info
    service { "net.${network_interface}":
      ensure => running,
      enable => true,
    }
  }

  service { acpid:
    ensure    => running,
    enable => true,
    require   => [
      Package[acpid],
    ],
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

  # The daemon needs to be running on all nodes which will be managed with mco
  # (even the admin server so the commands will be invoked on the invoking node)
  service { 'mcollectived':
    ensure  => running,
    enable  => true,
    subscribe => File['/etc/mcollective/server.cfg'],
    require => [
      Package[mcollective],
      File['/etc/mcollective/server.cfg'],
    ],
  }

  # ensure automatic updates of system hostname if it changes
  exec { 'hostname_update':
    command     => '/sbin/rc-service hostname restart',
    subscribe   => File['/etc/conf.d/hostname'],
    refreshonly => true,
    require     => [
      File['/etc/conf.d/hostname']
    ],
  }

  exec { "sysctl_update":
    command => "/sbin/sysctl --system",
    subscribe   => File['/etc/sysctl.conf'],
    refreshonly => true,
    require     => [
      File['/etc/sysctl.conf']
    ],
  }

  package { "app-misc/screen":
    ensure  => installed,
    require => [
      Layman['nitelite-a'],
      Layman['nitelite-b'],
    ],
  }

  # TODO: Remove the following section once testing is done

  # MCO TESTING

  file { "/usr/share/mcollective/plugins/mcollective/agent/nitelite.rb":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/share/mcollective/plugins/mcollective/agent/nitelite.rb",
    source => "puppet:///files/mcollective-nitelite/agent/nitelite.rb",
    require => Package[mcollective],
  }

  file { "/usr/share/mcollective/plugins/mcollective/agent/nitelite.ddl":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/share/mcollective/plugins/mcollective/agent/nitelite.ddl",
    source => "puppet:///files/mcollective-nitelite/agent/nitelite.ddl",
    require => Package[mcollective],
  }

  file { "/usr/share/mcollective/plugins/mcollective/application/nitelite.rb":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/share/mcollective/plugins/mcollective/application/nitelite.rb",
    source => "puppet:///files/mcollective-nitelite/application/nitelite.rb",
  }

}
