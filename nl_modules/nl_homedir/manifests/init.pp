class nl_homedir {

  define file (
    $user,
    $file,
    $mode = 0644,
    $owner = $user,
    $group = $user,
  ) {

    # Retrieve the user home path
    $home = "home_${user}"
    $home_path = inline_template("<%= scope.lookupvar('::$home') %>")

    # Ensure the home directories exist. If they don't, it'll cause a
    # duplicate compile error on the file
    if $home_path {

      file { "${home_path}/${file}":
        ensure => "file",
        owner  => "${owner}",
        group  => "${group}",
        mode   => "${mode}",
        source => "puppet:///files/homedir/${file}"
      }

    }

  }
}
