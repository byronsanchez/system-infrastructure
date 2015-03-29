# Reference Architecture

This is an overview of the architecure used for the internal.nitelite.io
network. Specific details are described in the other docs.

## Provisioning

## Configuration Management

## Maintenance and Updates

MAKE SURE TO HAVE YOUR DHCP SERVER PASS THE IPS TO THE LOCAL NAMESERVERS!

DMZ containing public facing hosts. anything exposed to the internet goes here
internal local subnet that does not communicate with hosts on the DMZ within
the internal local subnet, further subdivisions can occur as necessary: - web,
db and app server isolation using vlans - clustering based on type vs usage
(isolate dbs from apps versus via application type)

# securing communication channels tftp - plain text rsync - standard rsync is
in the clear, rsync over ssh is used for secure data transfer https - system
administration tools use ssl. http is redirected to https; stages and
development environments are not encrypted and use http

IMAPS - ssl is required SMTP - ssl is required syslog - tcp communication
occurs using ssl, udp is plain text stomp - ssl is required (6164) - can use
puppet certs since using mco

puppet - the network is using a masterless setup. thus, CAs are not needed.
However, all transfers of manifests and other configuration data should be done
over encrypted channels

rabbitmq - data cert 5672 mysql - my 3306 pgsql - pg 5432 ldap - ldap 636 vpn -
duh, its vpn it uses different layers of encryption and also has mutual certs.
just make sure you fully understand how you have the server and clients
configured

use nginx to terminate https connections

# ssl hostnames system certs are defined by the service they provide (vpn,
data, mail, etc)

CA directories - if no fqdn is used as a dir name, the dirname is implied to be
the hostname portion of the internal.nitelite.io network. fully defined fqdns
for dirnames are used for certs that must use another domain.

# network infrastructure design

this is currently a concept that i may want to implement after further research
and architecture refinement.

dev, stage and production boxes

2 physical servers for each environment - 1 master, 1 slave that syncs writes
from master

2 load balanceers for each environment - for redundancy

Thus, a maximum of 4 physical servers per environment. the 2 physical servers
run KVM hypervisor and house virtual guests for each of the needed servers, the
2 load balancers run bare-metal operating systems which will run HAProxy and
nginx

for horizontal scaling, consider researching a way to delegate requests to the
cloud if necessary. goal is to have a base infrastructure inhouse and to scale
using cloud services if load becomes high. though i am not currently sure if
this "hybrid" approach is a good one yet; i'll need to do more research

what about app, web and db server isolations on different physical servers?

If that was the case, the total amount of necessary physical servers would be
24? that seems overkill for development environments, possibly staging, though
staging should be an exact mirror (?).

Each hypervisor will need at least (based on previous hypervisor experience):

8 GB RAM Quad-core

Obviously, this will change significantly if there ends up being a split
between app, db and web servers, and any other services outside those domains

Physical seperation of each tier (web, app, db) allows horizontal scaling at
each tier. so this will be used for production. however one question still
bothers me. Is this architecture overkill for none-production environments.
logical separation isn't a bad way to go, but I don't want to commit to it
without having a very good understanding of the security implications, if any

I realize that you must still be able to test load-balance configuration nodes
and whether or not HA is functional. what about physical seperation. the stage
would probably contain 8 physical servers to closely mimic production. what
about the development environment?

so far

each env

2 lbs 2 web 2 app 2 dbs

and then, there are services that would only be useful in-house:

- CI build server - Proxy/Local web cache - VPN server - Centralized VCS with
web interface - LDAP for centralized authentication - Internal mail server -
Data server for log analysis - Internal DNS - PKI Server - Internal webserver
(to provide web interfaces for different administration nodes, like ldap)

another thing to think about is the implementation of a DMZ for public-facing
hosts. this will influence the design of the overall network infrastructure.
eg.  hardware seperation is simpler but more costly. logic seperation is
definitely possible, but more care is necessary to ensure the vms are segmented
properly with one way access TO the dmz but not FROM the dmz

