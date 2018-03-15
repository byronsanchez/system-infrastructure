# TODO: find a way to hiera-parse an array of hashes for rabbit mq accounts and
# perms so that the mcollective user can be abstracted. (this will decouple this
# amqp pattern from mcollective entirely!)
class amqp {

  $rabbitmq_mcollective_password= hiera('rabbitmq_mcollective_password', '')

  file { "/etc/mcollective/plugins.d/":
    ensure => present,
    mode => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/base/etc/conf.d/keymaps",
  }

  class { "::rabbitmq":
    port              => '5672',
    delete_guest_user => true,
    config_stomp      => true,
    stomp_port        => inline_template('{"<%= @ipaddress %>", 6163}'),
  }

  $rabbitmq_plugins = [
    "rabbitmq_stomp",
    "amqp_client",
  ]

  rabbitmq_plugin { $rabbitmq_plugins: ensure => present }

  rabbitmq_vhost { '/mcollective':
    ensure => present,
  }

  rabbitmq_user { 'mcollective':
    admin      => true,
    password => "${rabbitmq_mcollective_password}",
  }

  # Use the default / vhost
  rabbitmq_user_permissions { "mcollective@/mcollective":
    configure_permission => '.*',
    read_permission    => '.*',
    write_permission => '.*',
  }

  # Create the topic exchange
  rabbitmq_exchange { 'mcollective_broadcast@/mcollective':
    user     => 'mcollective',
    password => $rabbitmq_mcollective_password,
    type     => 'topic',
    ensure   => present,
  }

  # Create the direct exchange
  rabbitmq_exchange { 'mcollective_directed@/mcollective':
    user     => 'mcollective',
    password => $rabbitmq_mcollective_password,
    type     => 'direct',
    ensure   => present,
  }

}
