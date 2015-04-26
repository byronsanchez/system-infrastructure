class hypervisor {

  file { "/srv/kvm":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    mode    => '755',
    require => File["/srv"],
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

  $packages = [
    "libvirt",
    "bridge-utils",
  ]

  package { $packages:
    ensure  => installed,
  }

  service { 'libvirtd':
    ensure => 'running',
    enable => 'true',
    require => [
      Package[libvirt],
    ],
  }

}
