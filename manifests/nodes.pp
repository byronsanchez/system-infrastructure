# These values CANNOT be overwritten in "child" nodes. Once these are set, they
# must remain the same. Node inheritance cannot be used as a hierarchical
# solution that allows child nodes to override the configs.

node "network" {

  # network settings
  # TODO: account for differences between the internal and external domains
  $domain = "internal.nitelite.io"

  # network services
  $puppetmaster_address = "10.66.77.100"
  $mediaserver_address = "10.66.77.100"
  $ldapserver_address = "10.66.77.100"
  $binhost_address = "10.66.77.100"

}

import "nodes/*.pp"

