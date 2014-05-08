class ci {

  # TODO: require nitelite overlays
  $packages = [
    "jenkins-bin",
  ]

  # TODO: require nitelite overlays
  package {
    $packages: ensure => installed,
  }

  service { jenkins:
    ensure    => running,
    enable => true,
    require   => [
      Package[jenkins-bin],
    ],
  }

}
