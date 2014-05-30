class nl_hosts ($node_name = '') {
  file { '/etc/hosts':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nl_hosts/etc/hosts.erb'),
  }
}
