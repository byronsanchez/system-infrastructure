### Node naming convention

I currently do not require a formal naming convention, so I am simply using an
arbitrary naming scheme. I set up different nodes with different services (for
now), so even naming a node "puppet" does not show it may also run other server
applications (which in my use case, it may).

This may change in the future, but for now I will simply maintain a list of
hostnames and the services they provide.

Name - service mapping

maia = data
polaris = dns master
polaris2 = dns replication
kraz = proxy
kuma = mail
sol = puppet, binhost, provision, hypervisor, media, web (base)
electra = ldap master
electra2 = ldap replication
mira = workstation
alya = postgres
alya2 = postgres replication
atlas = mysql
atlas2 = mysql replication
vega = private ca
sirius = web (nitelite)
zosma = web (admin)
bellatrix = vpn
chow = central vcs
kastra = build server
chara|caph|decrux = isolated pentest

Network naming conventions

internal.nitelite.io are nodes on the local subnet and are used to directly
reference a node. DNS is handled on the private subnet.
nitelite.io are for any public service, public DNS

They way you're supposed to do it is have a private auth DNS server managing
internal.example.tld. Then all requests to example.tld can be forwarded to the
external public DNS server since you are not managing that. The way I'm
currently doing it is mirroring the public DNS server records on my local
network and adding records on top of that. It's redundant, but allows me to have
a local copy of external DNS records (since this is managed by another service)
as well as gives me full control of subdomain.example.tld, which I use
internally for staging and development; I don't want these on the public
servers.

development server names - dev.name.tld (needed when working with others)
staging server names - stage.name.tld
production app names - name.tld

Use internal DNS, hosts, nginx w/e to manage the names. Just make sure to not
make your dev environments public

### Volumes

luna = main file share
io = backup
europa = mirrors
rhea = kvm guest images
phobos = bootable usb install or recovery
deimos = 

