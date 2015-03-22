define nl_files(
  $owner,
  $group,
  $mode,
  $requires,
  $source,
  $file_type = '',
) {

  if $file_type == "template" {

    file { "$name":
      ensure  => present,
      path    => $name,
      owner   => $owner,
      group   => $group,
      require => $requires,
      content => template("${source}${name}.erb"),
    }

  }
  else {

    file { "$name":
      ensure  => present,
      path    => $name,
      owner   => $owner,
      group   => $group,
      require => $requires,
      source => "puppet:///files/${source}${name}",
    }

  }
}
