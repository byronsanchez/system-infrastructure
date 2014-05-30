define nl_files(
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
