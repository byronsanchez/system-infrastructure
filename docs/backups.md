# Backup System

The current implemented backup system has 3 layers.

## Workstation Infrastructure

There are three layers to the backup. Actually one layer is not a backup, so
there are two layers.

1. rsnapshot file backups
2. tarsnap remote backups

The other is rsync mirroring, for high-availability (this is MUCH better, than
having to resetup from scratch; yes the reprovisioning is automated, but
it's still time consuming). Rsync mirroring will be the workstation version of
"RAID" since RAID is not necessary and overkill for my purposes.

There is an external drive that will house all file backups. It primarily backs
up the data store partition, but will also backup files from the individual
operating systems if they are plugged in. The external drive is encrypted, just
like all workstation volumes are.

The same policies will hold for the remote backups. Except for one difference-
remote backups are encrypted before being sent to the remote destination.

The development VMs do not need to be backed up.

A limiting factor may be the size of the hard drive. The external is meant to be
purely for backup, so the onboard hard drive would need to server for all OSes
and the data store. I could allocate half of the drive to be OS storage and the
other half to be shared data storage.

Honestly, it looks like I'd need at least 500GB on my data share not counting OS
storage.

Also, have a spare computer that can be used as a backup. Maybe a Lenovo, or
something that will only be for the linux OS. This is just a temporary
workstation in case the other one goes down but I need to work, so don't go
overboard with it.

## Server Infrastructure

### RAID

The first layer is a RAID, so not a backup. Just HA.

### rsnapshot + encryption

The second layer is rsnapshot, which backups important files of all nodes. The
backups are copied to encrypted volume(s) using LUKS.

### tarsnap

The third and final layer is an offsite encrypted backup with tarsnap.

### general backup policy

- All volumes housing any of the backups are to be encrypted with LUKS or 
  another solution that is appropriate in the context.
- At least one offsite backup at a regular interval
- Daily automated testing of restoration (if reasonable) and occasional, but
   regular, testing of restoration for large amounts of data (if you haven't
  validated restoration, you don't have a backup)
- daily backups for last 7 days are kept (thus, at least 7)
- monthly backups for the past year are kept (thus, at least 12)

mirroring is not a backup if the mirror changes in response to changes on the
source (eg. delete on source will cause delete in mirror); since the mirror
can't actually be used to RESTORE lost data. but mirroring can be used.
mirroring CAN be used for redundancy or in a high-availability context. I'm
trying to understand why I might want to use it with a workstation.

RAID is not a backup. At best, it's for high-availability, performance, etc
(depending on RAID type)

Thus, mirroring and raid DO NOT fall under the data recovery category, they fall
under the high-availability category

ok so mirrors are HA. so a workstation mirror would just be to not have to spend
so much time reprovisioning, reinstalling, etc.

conclusion to broad categorizations with many implementations - HA vs. DR. make
sure you know which solution you are implementing (eg. RAID is never a backup,
just HA, same for mirrors, where as systems that allow point-in-time recovery
and that are VALIDATED are actually backups and can be used for DR)

### image backups

image backups are currently not implemented, but they are a goal for the
infrastructure.

consider how image backups might fit into this structure and determine
their relationship with provisioning images.

The point of image backups is QUICK recovery, to reduce time wasted in the
reprovisioning process of a machine. This is very similar to having provisioning
images ready.

I think for me, the difference between provisioning images and image backups lie
in configuration- provisioning images are bare-bones and are not yet defined in
purpose (eg. mysql, ldap, webserver, etc) where as image backups ARE configured
and may even house data relevant to its purpose.

File backup restorations would be more time consuming, but it is another
necessary layer of the backup cake. Then the image backups come in for the sole
purpose of quick recovery, just like provision images exist for the sole purpose
of QUICK configuration (as opposed to having to rebuild a new image every time
one is needed; the automation tools exist for this, but it is still time
consuming)

partial restores are usually not possible; it's often all or nothing

TODO: research how tape backup policies work and whether or not they would be
appropriate in the current context

TODO: limit time window the backup server is on the network

## Other Notes

### Apple Documentation Backups

iOS documentation is not backed up via these mirroring scripts. So long as you 
have a Mac developer workstation and install the DocSets via Xcode, rsnapshot 
backups will contain the docsets.

However, if you remove the mac workstation from the rsnapshot backup plan, 
write a script for downloading the docsets as part of this mirroring system.
