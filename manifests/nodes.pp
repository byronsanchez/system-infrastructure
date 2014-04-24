# These values CANNOT be overwritten in "child" nodes. Once these are set, they
# must remain the same. Node inheritance cannot be used as a hierarchical
# solution that allows child nodes to override the configs.

node "network" {

  # network settings
  # TODO: account for differences between the internal and external domains
  $domain = "internal.nitelite.io"
  $internal_domain = "internal.nitelite.io"
  $external_domain = "external.nitelite.io"

  # network services
  $puppetmaster_address = "10.66.77.100"
  $hypervisor_address = "10.66.77.100"
  $mediaserver_address = "10.66.77.100"
  $binhost_address = "10.66.77.100"
  $ns1_address = "10.66.77.101"
  $ns2_address = "10.66.77.102"
  $ldapserver_address = "10.66.77.103"

}

import "nodes/*.pp"

