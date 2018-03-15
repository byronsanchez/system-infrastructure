class root {

  $passwords = hiera("passwords", "")

  if $passwords {
    $password = $passwords['root']
  }

  if $password {

    user { 'root':
      ensure   => 'present',
      password => $password,
    }

  }

}
