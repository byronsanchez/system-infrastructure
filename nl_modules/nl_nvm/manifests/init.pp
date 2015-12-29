class nl_nvm(
  $user,
  $home,
) {

  define user_install (
    $user,
    $home,
  ) {

    vcsrepo { "${home}/.nvm":
      ensure   => present,
      provider => git,
      source   => "git://github.com/creationix/nvm.git",
      user     => "${user}",
    }

  }

}
