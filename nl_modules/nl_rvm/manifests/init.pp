class nl_rvm {

  define user_install (
    $user,
    $home,
  ) {
    exec { "rvm_install_${user}":
      cwd     => "${home}",
      # Install rvm-stable in the home directory without touching the dotfiles.
      # dotfiles are managed seperately (*rc and *profile)
      # Removed the -- for zsh shells
      command => "/usr/bin/gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3; /usr/bin/curl -sSL https://get.rvm.io | /bin/bash -s stable --ignore-dotfiles; /usr/bin/gem install rails",
      creates => "${home}/.rvm",
      user    => "${user}",
    }

  }
}
