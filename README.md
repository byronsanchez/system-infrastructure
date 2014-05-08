# Puppet

Configuration management for Gentoo nodes.

## Notes

These are just some notes I'm keeping for myself. I'll build this into a proper 
README doc as I go along.

PS. source for general structure comes from: 
http://swift.siphos.be/aglara/centralcmdb.html

I used that as my base and started building up from there.

### Portage Module

Most of the manifests do not make use of the portage module, favoring standard
portage files. The portage module is an advantageous consideration since it
would directly add puppet features instead of having to write out logic as erb
templates in the actual files. There is currently no need for this in this
puppet project, but future requirements or refactorings may benefit from more of
the portage module features.

Currently, the portage module is used to implement the eselect and layman 
features.

### Incompatible Patterns

Some patterns are incompatible. They define resource types that would cause a
collision- attempting to have both resources on the same node would result in
error.

Here is the list of incompatible patterns:

  - workstation.pp and mail.pp - both define an MTA package resource. Only one
    MTA can be installed per node at a time. mail.pp uses postfix for
    network-wide send only delivery of mail, whereas workstation.pp uses msmtp
    for simple workstation delivery of mail
  - vpn.pp and webserver.pp - both use port 443 - webserver uses it for https
    connections and vpn uses it for vpn connections

### Building Configs From Fragments

If conf.d structures are supported, use that. Otherwise, use augeas.

