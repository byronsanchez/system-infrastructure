class vcs {

  $packages = [
    #"git",
    "mercurial",
    "subversion",
    "bzr",
    "rcs",
  ]

  package { $packages: ensure => installed }

}
