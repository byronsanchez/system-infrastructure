# servers  get the postfix setup. clients get the msmtp setup
# typically, one server on the network, and as many clients as needed
class mail($mail_type) {

  define myFiles(
    $owner,
    $group,
    $mode,
    $requires,
    $source,
  ) {
    file { "$name":
      ensure  => present,
      path    => $name,
      owner   => $owner,
      group   => $group,
      require => $requires,
      source => "puppet:///files/${source}${name}",
    }
  }

  $gmailuser = hiera('gmailuser', '')
  $gmailpw = hiera('gmailpw', '')
  $mailreaderpw = hiera('mailreaderpw', '')

  if $mail_type == "server" {

    user { 'vmail':
      ensure => 'present',
      managehome => true,
      gid    => '5000',
      home       => '/srv/vmail',
      shell  => '/bin/false',
      uid    => '5000',
    }

    group { 'vmail':
      ensure => 'present',
      gid    => '5000',
    }

    file { "/srv/vmail":
      ensure => directory,
      owner  => vmail,
      group  => vmail,
      mode   => 2770,
      require => [
        User[vmail],
        Group[vmail],
      ],
    }

    $server_packages = [
      "dovecot",
      #"amavisd-new",
      #"spamassassin",
      #"clamav",
      #"gld",
    ]

    package { $server_packages:
      ensure  => installed,
    }

    file { "/etc/postfix/virtual_alias_maps.cf":
      ensure => present,
      owner  => "postfix",
      group  => "postfix",
      mode   => 0644,
      path   => "/etc/postfix/virtual_alias_maps.cf",
      content => template("mail/etc/postfix/virtual_alias_maps.cf.erb"),
      require => File["/etc/postfix"],
    }

    file { "/etc/postfix/virtual_domain_maps.cf":
      ensure => present,
      owner  => "postfix",
      group  => "postfix",
      mode   => 0644,
      path   => "/etc/postfix/virtual_domain_maps.cf",
      content => template("mail/etc/postfix/virtual_domain_maps.cf.erb"),
      require => File["/etc/postfix"],
    }

    file { "/etc/postfix/virtual_mailbox_limits.cf":
      ensure => present,
      owner  => "postfix",
      group  => "postfix",
      mode   => 0644,
      path   => "/etc/postfix/virtual_mailbox_limits.cf",
      content => template("mail/etc/postfix/virtual_mailbox_limits.cf.erb"),
      require => File["/etc/postfix"],
    }

    file { "/etc/postfix/virtual_mailbox_maps.cf":
      ensure => present,
      owner  => "postfix",
      group  => "postfix",
      mode   => 0644,
      path   => "/etc/postfix/virtual_mailbox_maps.cf",
      content => template("mail/etc/postfix/virtual_mailbox_maps.cf.erb"),
      require => File["/etc/postfix"],
    }

    file { "/etc/portage/package.use/clamav":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/clamav",
      source => "puppet:///files/mail/etc/portage/package.use/clamav",
    }

    file { "/etc/postfix/transport":
      ensure => present,
      owner  => "postfix",
      group  => "postfix",
      mode   => 0644,
      path   => "/etc/postfix/transport",
      source => "puppet:///files/mail/etc/postfix/transport",
      require => File["/etc/postfix"],
    }

    file { "/etc/postfix/vdomain":
      ensure => present,
      owner  => "postfix",
      group  => "postfix",
      mode   => 0644,
      path   => "/etc/postfix/vdomain",
      source => "puppet:///files/mail/etc/postfix/vdomain",
      require => File["/etc/postfix"],
    }

    file { "/etc/postfix/vmailbox":
      ensure => present,
      owner  => "postfix",
      group  => "postfix",
      mode   => 0644,
      path   => "/etc/postfix/vmailbox",
      source => "puppet:///files/mail/etc/postfix/vmailbox",
      require => File["/etc/postfix"],
    }

    #################
    # DOVECOT CONFIGS

    file { "/etc/dovecot":
      ensure  => "directory",
      recurse => true,
      owner   => "dovecot",
      group   => "dovecot",
    }

    file { "/etc/dovecot/conf.d":
      ensure  => "directory",
      recurse => true,
      owner   => "dovecot",
      group   => "dovecot",
      require => File["/etc/dovecot"],
    }

    file { "/etc/dovecot/dovecot.conf":
      ensure => present,
      owner  => "dovecot",
      group  => "dovecot",
      mode   => 0644,
      path   => "/etc/dovecot/dovecot.conf",
      source => "puppet:///files/mail/etc/dovecot/dovecot.conf",
      require => File["/etc/dovecot"],
    }

    file { "/etc/dovecot/dovecot-sql.conf.ext":
      ensure => present,
      owner  => "dovecot",
      group  => "dovecot",
      mode   => 0644,
      path   => "/etc/dovecot/dovecot-sql.conf.ext",
      content => template("mail/etc/dovecot/dovecot-sql.conf.ext.erb"),
      require => File["/etc/dovecot"],
    }

    # TODO: refine this file array style of resource declaration and apply it to
    # all classes where possible to reduce redundancy (eg. all conf.d type
    # files)
    #
    # TODO: start tracking all files for all managed apps

    $dovecot_files = [
      "/etc/dovecot/conf.d/10-auth.conf",
      "/etc/dovecot/conf.d/10-director.conf",
      "/etc/dovecot/conf.d/10-logging.conf",
      "/etc/dovecot/conf.d/10-mail.conf",
      "/etc/dovecot/conf.d/10-master.conf",
      "/etc/dovecot/conf.d/10-ssl.conf",
      "/etc/dovecot/conf.d/15-lda.conf",
      "/etc/dovecot/conf.d/15-mailboxes.conf",
      "/etc/dovecot/conf.d/20-imap.conf",
      "/etc/dovecot/conf.d/20-lmtp.conf",
      "/etc/dovecot/conf.d/20-pop3.conf",
      "/etc/dovecot/conf.d/90-acl.conf",
      "/etc/dovecot/conf.d/90-plugin.conf",
      "/etc/dovecot/conf.d/90-quota.conf",
      "/etc/dovecot/conf.d/auth-checkpassword.conf.ext",
      "/etc/dovecot/conf.d/auth-deny.conf.ext",
      "/etc/dovecot/conf.d/auth-dict.conf.ext",
      "/etc/dovecot/conf.d/auth-ldap.conf.ext",
      "/etc/dovecot/conf.d/auth-master.conf.ext",
      "/etc/dovecot/conf.d/auth-passwdfile.conf.ext",
      "/etc/dovecot/conf.d/auth-sql.conf.ext",
      "/etc/dovecot/conf.d/auth-static.conf.ext",
      "/etc/dovecot/conf.d/auth-system.conf.ext",
      "/etc/dovecot/conf.d/auth-vpopmail.conf.ext",
    ]

    myFiles { $dovecot_files:
      owner    => 'dovecot',
      group    => 'dovecot',
      mode     => 0644,
      requires  => File["/etc/dovecot/conf.d"],
      source => 'mail',
    }

    # Update the postfix lookup table whenever vmailbox file is updated
    exec { "postmap_vmailbox_update":
      command => "/usr/sbin/postmap /etc/postfix/vmailbox",
      subscribe   => File['/etc/postfix/vmailbox'],
      refreshonly => true,
      require => [
        Package[postfix],
        File['/etc/postfix/vmailbox'],
      ],
    }

    # Update the postfix lookup table whenever transport file is updated
    exec { "postmap_transport_update":
      command => "/usr/sbin/postmap /etc/postfix/transport",
      subscribe   => File['/etc/postfix/transport'],
      refreshonly => true,
      require => [
        Package[postfix],
        File['/etc/postfix/transport'],
      ],
    }

    # Update the postfix lookup table whenever vdomain file is updated
    exec { "postmap_vdomain_update":
      command => "/usr/sbin/postmap /etc/postfix/vdomain",
      subscribe   => File['/etc/postfix/vdomain'],
      refreshonly => true,
      require => [
        Package[postfix],
        File['/etc/postfix/vdomain'],
      ],
    }

    service { 'dovecot':
      ensure  => running,
      enable  => true,
      subscribe => File['/etc/dovecot/dovecot.conf'],
      require => [
        Package[dovecot],
        File['/etc/dovecot/dovecot.conf']
      ],
    }

  }

  file { "/etc/portage/package.use/postfix":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/postfix",
    source => "puppet:///files/mail/etc/portage/package.use/postfix",
  }

  # sendmail aliases
  file { "/etc/aliases":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/aliases",
    source => "puppet:///files/mail/etc/aliases",
  }

  # postfix aliases
  file { "/etc/mail/aliases":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/mail/aliases",
    source => "puppet:///files/mail/etc/mail/aliases",
  }

  file { "/etc/postfix/virtual":
    ensure => present,
    owner  => "postfix",
    group  => "postfix",
    mode   => 0644,
    path   => "/etc/postfix/virtual",
    content => template("mail/etc/postfix/virtual.erb"),
    require => File["/etc/postfix"],
  }

  file { "/etc/postfix":
    ensure  => "directory",
    recurse => true,
    owner   => "postfix",
    group   => "postfix",
  }

  file { "/etc/postfix/main.cf":
    ensure => present,
    owner  => "postfix",
    group  => "postfix",
    mode   => 0644,
    path   => "/etc/postfix/main.cf",
    content => template("mail/etc/postfix/main.cf.erb"),
    require => File["/etc/postfix"],
  }

  file { "/etc/postfix/master.cf":
    ensure => present,
    owner  => "postfix",
    group  => "postfix",
    mode   => 0644,
    path   => "/etc/postfix/master.cf",
    source => "puppet:///files/mail/etc/postfix/master.cf",
    require => File["/etc/postfix"],
  }

  file { "/etc/postfix/saslpass":
    ensure => present,
    owner  => "postfix",
    group  => "postfix",
    mode   => 0644,
    path   => "/etc/postfix/saslpass",
    content => template("mail/etc/postfix/saslpass.erb"),
    require => File["/etc/postfix"],
  }

  $packages = [
    "postfix",
  ]

  package { $packages:
    ensure  => installed,
  }

  service { 'postfix':
    ensure  => running,
    enable  => true,
    subscribe => File['/etc/postfix/main.cf'],
    require => [
      Package[postfix],
      File['/etc/postfix/main.cf']
    ],
  }

  # Update the postfix lookup table whenever saslpass file is updated
  # this needs to run at least once
  exec { "postmap_saslpass_update":
    command => "/usr/sbin/postmap /etc/postfix/saslpass",
    subscribe   => File['/etc/postfix/saslpass'],
    require => [
      Package[postfix],
      File['/etc/postfix/saslpass'],
    ],
  }

  # Update the postfix lookup table whenever virtual file is updated
  # this needs to run at least once
  exec { "postmap_virtual_update":
    command => "/usr/sbin/postmap /etc/postfix/virtual",
    subscribe   => File['/etc/postfix/virtual'],
    require => [
      Package[postfix],
      File['/etc/postfix/virtual'],
    ],
  }

  # Update the alias lookup table whenever aliases file is updated
  # this needs to run at least once
  exec { "aliases_update":
    command => "/usr/bin/newaliases",
    subscribe   => File['/etc/mail/aliases'],
    require => [
      Package[postfix],
      File['/etc/mail/aliases'],
    ],
  }

}

