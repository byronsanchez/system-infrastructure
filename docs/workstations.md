# Workstations

Notes on workstations and their infrastructure

Workstation file backups should be done seperately. Similar policies but managed
by the workstation as opposed to the backup server.

I was looking at different ways to manage different OSes. I intend to develop
for linux, OSX and Windows, so triple boot seems the best, most flexible option
  (carrying three laptops is a pain).

The other problem was the data share.

So my new idea is to have a seperate workstation backup system and have core
data shared among three partitions.

Drivers seem unstable and complete for local rw access between all three OSes,
so it seems an alternative solution is necessary.

I think the most reliable solution is to house the core data on the linux
partition (which would be my primary OS) and share that to the windows and osx
OSes. The sharing would be done through an NFS share using a virtualized linux
guest.

This is how:

4 partitions - 1 for each OS, and 1 containing an ext4 file system for core data
On windows and osx, assign that data partition as a second hard drive to the
guest instance. Then use that guest instance to share the data back to the host
via NFS.

This would actually fit into my current workstation infrastructure nicely. I
have vagrant configured to host a single VM on my workstations. I believe I just
need to adapt that to windows (it already works with osx), then type `vagrant
up`, have it auto-configure the NFS and I am good to go.

This will consume resources, so my workstation will need to be able to account
for that overhead as well as be able to simulataneously run processes I use for
  my work. I can probably just configure the vagrant VM I use for web dev to
  pass the data share to the host (docker is what's actually used in the VM).

### other notes i wrote down while designing my infrastructure

KVM Tower for staging, testing and as the core of my network
  - hosts file shares and any other critical network tool

Laptop for portable development
  - Macbook Pro

The Ideal Network (so far...)

  1 dedicated virtualization machine
    - for development staging, testing, servers, etc.
  1 Macbook Pro
    - portable audio and video editing
    - running DE apps for business
    - portable apple dev
    - triple boot

