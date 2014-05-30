class hypervisor {

  file { "/srv/kvm":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    mode    => '755',
    require => File["/srv"],
  }

  file { "/etc/portage/package.use/virt-manager":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/virt-manager",
    source => "puppet:///files/hypervisor/etc/portage/package.use/virt-manager",
  }

  file { "/etc/libvirt":
    ensure => "directory",
    owner => "root",
    group => "root",
  }

  file { "/etc/libvirt/libvirtd.conf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/libvirt'],
    path => "/etc/libvirt/libvirtd.conf",
    source => "puppet:///files/hypervisor/etc/libvirt/libvirtd.conf",
  }

  file { "/etc/libvirt/libvirt.conf":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/libvirt'],
    path => "/etc/libvirt/libvirt.conf",
    source => "puppet:///files/hypervisor/etc/libvirt/libvirt.conf",
  }

  file { '/etc/cron.daily/backup_virtdomains':
    ensure  => present,
    path    => "/etc/cron.daily/backup_virtdomains",
    source  => 'puppet:///files/hypervisor/etc/cron.daily/backup_virtdomains',
    group   => '0',
    owner   => '0',
    mode    => 0755,
    require => File['/etc/cron.daily'],
  }

  $packages = [
    "libvirt",
    "virt-manager",
    "bridge-utils",
    "virt-viewer",
  ]

  package { $packages:
    ensure => installed,
  }

  service { 'libvirtd':
    ensure => 'running',
    enable => 'true',
    require => [
      Package[libvirt],
    ],
  }

  #service { 'libvirt-guests':
  #  ensure => 'running',
  #  enable => 'true',
  #  require => [
  #    Package[libvirt],
  #  ],
  #}

}
