class ruby {

  # TODO: require nitelite overlays
  $packages = [
    "dev-ruby/rvm",
  ]

  package { $packages:
    ensure => installed,
  }

}
