class nl_ssh {

  define ssh {

    $user = $name

    # Retrieve the user home path
    $home = "home_${user}"
    $home_path = inline_template("<%= scope.lookupvar('::$home') %>")

    # Ensure the home directories exist. If they don't, it'll cause a
    # duplicate compile error on /.ssh
    if $home_path {

      # Ensure permission and owndership is properly set for the user's ssh
      # directory
      file { "${home_path}/.ssh":
        ensure  => "directory",
        owner   => "${user}",
        group   => "${user}",
        recurse => true,
        mode    => 0700,
      }

    }

    # AUTHORIZED KEYS WHEN ROLE == SERVER

    $all_authorized_keys = hiera('authorized_keys', "")
    
    if $all_authorized_keys {
      $user_authorized_keys = $all_authorized_keys["${user}"]
    }

    if $user_authorized_keys {
      $keys = $user_authorized_keys["keys"]
      $options = $user_authorized_keys["options"]

      nl_ssh_authorized_key { $keys:
        user    => $user,
        options => $options,
      }

    }

    # TODO: KNOWN HOSTS WHEN ROLE == SERVER


    # CONFIGS WHEN ROLE == CLIENT

    # retrieve a merge of ALL hiera config files containing the ssh_configs hash
    if $home_path {

      $all_configs = hiera_hash('ssh_configs', "")

      if $all_configs {
        $user_configs = $all_configs["${user}"]
      }

      if $user_configs {

        file { "${home_path}/.ssh/config":
          ensure => present,
          owner => "${user}",
          group => "${user}",
          mode => 0644,
          path => "${home_path}/.ssh/config",
          content => template("nl_ssh/config.erb"),
        }

      }

    }
  }

  # Needed to process ssh key arrays
  define nl_ssh_authorized_key($user, $options) {

    # TODO: This makes the comment also contain the key. Find another unique value to
    # store instead when dealing with multiple keys for a single user.
    ssh_authorized_key { "${user}-${name}":
      ensure  => present,
      type    => 'ssh-rsa',
      user    => $user,
      key     => $name,
      options => $options,
    }

  }

}
