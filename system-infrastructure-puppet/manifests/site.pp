import "nodes.pp"
import "patterns/*.pp"
import "users/*.pp"

Package {
  require => [
    Exec['create_eix_cache'],
    File['/etc/portage/make.conf'],
    File['/etc/portage/repos.conf'],
  ],
}

