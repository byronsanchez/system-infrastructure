class ruby {

  $packages = [
    # needed to compile rubies for rvm
    "net-misc/curl",
    "sys-devel/patch",
    "app-shells/bash",
    "virtual/libiconv",
    "sys-libs/readline",
    "sys-libs/zlib",
    "dev-libs/openssl",
    "dev-libs/libyaml",
    "dev-db/sqlite",
    "sys-devel/libtool",
    "sys-devel/gcc",
    "sys-devel/autoconf",
    "sys-devel/automake",
    "sys-devel/bison",
    "sys-devel/m4",
  ]

  package { $packages:
    ensure => installed,
  }

}
