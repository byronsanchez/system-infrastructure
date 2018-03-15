class mobile {

  $packages = [
    "android-sdk-update-manager",
    "ant",
    "maven-bin",
    "gradle-bin",
  ]

  package { $packages: ensure => 'installed' }

}
