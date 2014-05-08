class pki(
  $ca_type,
  $ca_owner = '',
  $ca_group = '',
) {

  define nl_ca(
    $owner = '',
    $group = '',
  ) {

    $ca_type = $name

    if $owner {
      $realOwner = $owner
    }
    else {
      $realOwner = 'root'
    }

    if $group {
      $realGroup = $group
    }
    else {
      $realGroup = 'root'
    }

    file { "/etc/ssl/${ca_type}":
      ensure  => directory,
      owner   => "${realOwner}",
      group   => "${realGroup}",
    }

    file { "/etc/ssl/${ca_type}/private":
      ensure  => directory,
      owner   => "${realOwner}",
      group   => "${realGroup}",
      require => File["/etc/ssl/${ca_type}"],
    }

    file { "/etc/ssl/${ca_type}/cacert.pem":
      ensure => present,
      owner => "${realOwner}",
      group => "${realGroup}",
      mode => 0644,
      path => "/etc/ssl/${ca_type}/cacert.pem",
      source => "puppet:///secure/ssl/${ca_type}/cacert.pem",
    }

    file { "/etc/ssl/${ca_type}/private/cakey.pem":
      ensure => present,
      owner => "${realOwner}",
      group => "${realGroup}",
      mode => 0600,
      path => "/etc/ssl/${ca_type}/private/cakey.pem",
      source => "puppet:///secure/ssl/${ca_type}/private/cakey.pem",
    }

    file { "/etc/ssl/${ca_type}/private/cakey.pem.unencrypted":
      ensure => present,
      owner => "${realOwner}",
      group => "${realGroup}",
      mode => 0600,
      path => "/etc/ssl/${ca_type}/private/cakey.pem.unencrypted",
      source => "puppet:///secure/ssl/${ca_type}/private/cakey.pem.unencrypted",
    }

  }

  if $ca_type == "server" {

    $csrpullerpw = hiera('csrpullerpw', '')

    user { 'csrpuller':
      ensure => 'present',
      managehome => true,
      gid    => '5001',
      home       => '/home/csrpuller',
      shell  => '/bin/false',
      uid    => '5001',
    }

    group { 'csrpuller':
      ensure => 'present',
      gid    => '5001',
    }

    file { "/home/csrpuller":
      ensure  => directory,
      owner   => csrpuller,
      group   => csrpuller,
      mode    => 0755,
      require => [
        User[csrpuller],
        Group[csrpuller],
      ],
    }

    file { '/etc/fetchmailrc':
      ensure  => present,
      path    => "/etc/fetchmailrc",
      owner   => 'fetchmail',
      group   => 'fetchmail',
      mode    => 0600,
      content => template('pki/etc/fetchmailrc.erb'),
    }

    file { '/etc/procmailrc':
      ensure  => present,
      path => "/etc/procmailrc",
      source => 'puppet:///files/pki/etc/procmailrc',
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
    }

    file { "/home/csrpuller/requests":
      ensure => "directory",
      owner  => "csrpuller",
      group  => "csrpuller",
      mode   => 0755,
    }

    $server_packages = [
      "fetchmail",
      "procmail",
      "mpack",
    ]

    package { $server_packages: ensure => installed }

    service { 'fetchmail':
      ensure  => running,
      enable  => true,
      require => [
        Package[fetchmail],
      ],
    }

  }

  if ($ca_type != "server") and ($ca_type != "client") {

    if $ca_owner {
      $realOwner = $ca_owner
    }
    else {
      $realOwner = 'root'
    }

    if $ca_group {
      $realGroup = $ca_group
    }
    else {
      $realGroup = 'root'
    }

    nl_ca { $ca_type:
      owner => $realOwner,
      group => $realGroup,
    }

  }
  elsif $ca_type == "server" {

    $ca_types = [
      "data",
      "ldap",
      "mail",
      "nitelite.io",
      "vpn",
      "niteliteCA-root",
      "niteliteCA-system",
      "niteliteCA-user",
      "my",
      "pg",
      "puppet",
    ]

    # every file will be owned as root since this node will only house the files
    # and not actually use them
    nl_ca { $ca_types: }

  }

  file { "/etc/ssl/openssl.cnf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/ssl/openssl.cnf",
    content => template("pki/etc/ssl/openssl.cnf.erb"),
  }

  file { "/etc/ca-certificates.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    path    => "/etc/ca-certificates.conf",
    source  => "puppet:///files/pki/etc/ca-certificates.conf",
  }

  file { "/usr/local/bin/certcli.sh":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    path   => "/usr/local/bin/certcli.sh",
    source => "puppet:///files/pki/usr/local/bin/certcli.sh",
  }

  # INSTALL GLOBAL CERTS

  file { "/usr/share/ca-certificates/nitelite.io":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    require => Package['ca-certificates'],
  }

  file { "/usr/local/share":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    require => Package['ca-certificates'],
  }

  file { "/usr/local/share/ca-certificates":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    require => File['/usr/local/share'],
  }

  file { "/usr/local/share/ca-certificates/nitelite.io":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    require => File['/usr/local/share/ca-certificates'],
  }

  file { "/usr/share/ca-certificates/nitelite.io/niteliteCA-root.crt":
    ensure  => present,
    owner   => "root",
    group   => "root",
    require => File['/usr/share/ca-certificates/nitelite.io'],
    path    => "/usr/share/ca-certificates/nitelite.io/niteliteCA-root.crt",
    source  => "puppet:///secure/ssl/niteliteCA-root/cacert.pem",
  }

  file { "/usr/share/ca-certificates/nitelite.io/niteliteCA-system.crt":
    ensure  => present,
    owner   => "root",
    group   => "root",
    require => File['/usr/share/ca-certificates/nitelite.io'],
    path    => "/usr/share/ca-certificates/nitelite.io/niteliteCA-system.crt",
    source  => "puppet:///secure/ssl/niteliteCA-system/cacert.pem",
  }

  file { "/usr/share/ca-certificates/nitelite.io/niteliteCA-user.crt":
    ensure  => present,
    owner   => "root",
    group   => "root",
    require => File['/usr/share/ca-certificates/nitelite.io'],
    path    => "/usr/share/ca-certificates/nitelite.io/niteliteCA-user.crt",
    source  => "puppet:///secure/ssl/niteliteCA-user/cacert.pem",
  }

  $packages = [
    "openssl",
    "ca-certificates",
  ]

  package { $packages: ensure => installed }

  exec { "certificates_update":
    command => "/usr/sbin/update-ca-certificates",
    subscribe   => File['/etc/ca-certificates.conf'],
    require => [
      Package['ca-certificates'],
      File['/etc/ca-certificates.conf'],
      File['/usr/share/ca-certificates/nitelite.io/niteliteCA-root.crt'],
      File['/usr/share/ca-certificates/nitelite.io/niteliteCA-system.crt'],
      File['/usr/share/ca-certificates/nitelite.io/niteliteCA-user.crt'],
    ],
  }

}
