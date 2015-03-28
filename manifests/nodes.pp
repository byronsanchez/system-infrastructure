# These values CANNOT be overwritten in "child" nodes. Once these are set, they
# must remain the same. Node inheritance cannot be used as a hierarchical
# solution that allows child nodes to override the configs.

node "network" {

  # network settings
  # TODO: make sure all references to nitelite.io are not hardcoded in templates
  # or modules or files
  $domain = "nitelite.io"
  $internal_domain = "internal.${domain}"

  # network services
  # TODO: instead of using these variables, let DNS do most of the work and just
  # call standard fqdns in config files
  $puppetmaster_address = "10.66.77.100"
  $hypervisor_address = "10.66.77.100"
  $mediaserver_address = "10.66.77.100"
  $binhost_address = "10.66.77.100"
  $ns1_address = "10.66.77.101"
  $ns2_address = "10.66.77.102"
  $ldapserver_address = "10.66.77.103"
  $pgmaster_address = "10.66.77.108"
  $mymaster_address = "10.66.77.110"
  $vpn_address = "10.66.77.115"
  $vcs_address = "10.66.77.116"

}

import "nodes/*.pp"

