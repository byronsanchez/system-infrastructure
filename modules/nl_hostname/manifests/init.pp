define nl_hostname ($node_name = '') {

  if $node_name {
    file { "/etc/conf.d/hostname":
      ensure => present,
      mode => 0644,
      owner => "root",
      group => "root",
      content => template("nl_hostname/etc/conf.d/hostname.erb"),
    }
  }

}
