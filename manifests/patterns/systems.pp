# internal web-apps
#
# typically, these will be nginx front-ends that will talk to the actual target app
# that was installed and configured by another pattern (eg. ci, vcs, etc.).
# These front-ends provide the public access points. The back-ends should not be
# directly publically accessible.
class systems(
  $cgit = false,
  $fossil = false,
  $jenkins = false,
) {

  nl_nginx::website { "systems":
    websiteName     => "systems.nitelite.io",
    environmentName => "production",
    feed_path       => "systems",
    root_path       => "/htdocs",
    enable_ssl      => true,
    enable_php      => true,
    ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
    ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
  }

  if $cgit {

    # cgit internal frontend nginx for https
    nl_nginx::website { "git":
      websiteName     => "git.internal.nitelite.io",
      environmentName => "production",
      feed_path       => "git",
      root_path       => "/htdocs",
      enable_ssl      => true,
      ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass      => "http://cgitserver",
      proxy_redirect  => "http://cgit.internal.nitelite.io:8081/ https://git.internal.nitelite.io/",
      upstream        => "cgitserver",
      # non-cgi scripts will be handled by the fossil server
      upstream_server => "cgit.internal.nitelite.io:8081",
    }

  }

  if $fossil {

    # fossil internal frontend nginx for https
    nl_nginx::website { "fossil":
      websiteName     => "fossil.internal.nitelite.io",
      environmentName => "production",
      feed_path       => "fossil",
      root_path       => "/htdocs",
      enable_custom_configs => true,
      enable_ssl      => true,
      enable_cgi      => true,
      # cgi scripts sent here
      cgi_server      => "fs.internal.nitelite.io:3128",
      ssl_cert_path   => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path    => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass      => "http://fossilserver",
      proxy_redirect  => "http://fs.internal.nitelite.io:4545/ https://fossil.internal.nitelite.io/",
      upstream        => "fossilserver",
      # non-cgi scripts will be handled by the fossil server
      upstream_server => "fs.internal.nitelite.io:4545",
    }

    file { "/etc/nginx/conf.d/nitelite/fossil.internal.nitelite.io":
      ensure => present,
      owner => "root",
      group => "root",
      require => File['/etc/nginx/conf.d/nitelite'],
      path => "/etc/nginx/conf.d/nitelite/fossil.internal.nitelite.io",
      source =>
      "puppet:///files/systems/etc/nginx/conf.d/nitelite/fossil.internal.nitelite.io",
    }

  }

  if $jenkins {

    nl_nginx::website { "ci":
      websiteName       => "ci.nitelite.io",
      environmentName   => "production",
      feed_path         => "ci",
      root_path         => "/htdocs",
      enable_ssl        => true,
      ssl_cert_path     => "/etc/ssl/nitelite.io/cacert.pem",
      ssl_key_path      => "/etc/ssl/nitelite.io/private/cakey.pem.unencrypted",
      proxy_pass        => "http://jenkins.internal.nitelite.io:8080",
    }

  }

}
