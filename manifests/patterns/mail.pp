# servers  get the postfix setup. clients get the msmtp setup
# typically, one server on the network, and as many clients as needed
class mail($mail_type) {

  $gmailuser = hiera('gmailuser', '')
  $gmailpw = hiera('gmailpw', '')

  if $mail_type == "server" {

    file { "/etc/portage/package.use/awstats":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/awstats",
      source => "puppet:///files/mail/etc/portage/package.use/awstats",
    }

    file { "/etc/portage/package.use/clamav":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/clamav",
      source => "puppet:///files/mail/etc/portage/package.use/clamav",
    }

    file { "/etc/portage/package.use/cyrus-sasl":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/cyrus-sasl",
      source => "puppet:///files/mail/etc/portage/package.use/cyrus-sasl",
    }

    file { "/etc/portage/package.use/postfix":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/portage/package.use'],
      path => "/etc/portage/package.use/postfix",
      source => "puppet:///files/mail/etc/portage/package.use/postfix",
    }

    file { "/etc/aliases":
      ensure => present,
      owner => "root",
      group => "root",
      path => "/etc/aliases",
      source => "puppet:///files/mail/etc/aliases",
    }

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
    #"webmin",
    #"postfixadmin",
    #"roundcube",
    #"awstats",
    #"postgresql-server",
    #"courier-imap",
    #"courier-authlib",
    #"cyrus-sasl",
    #"amavisd-new",
    #"spamassassin",
    #"clamav",
    "postfix",
    #"gld",
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
  exec { "postmap_update":
    command => "/usr/sbin/postmap /etc/postfix/saslpass",
    subscribe   => File['/etc/postfix/saslpass'],
    refreshonly => true,
    require => [
      Package[postfix],
      File['/etc/postfix/saslpass'],
    ],
  }

}

