class nl_rvm(
  $user,
  $home,
) {

  exec { "rvm_install":
    cwd     => "${home}",
    # Install rvm-stable in the home directory without touching the dotfiles.
    # dotfiles are managed seperately (*rc and *profile)
    command => "/usr/bin/curl -sSL https://get.rvm.io | bash -s stable -- --ignore-dotfiles",
    creates => "${home}/.rvm",
    user    => "${user}",
  }

}
