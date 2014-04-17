###Apple Documentation Backups

iOS documentation is not backed up via these mirroring scripts. So long as you 
have a Mac developer workstation and install the DocSets via Xcode, rsnapshot 
backups will contain the docsets.

However, if you remove the mac workstation from the rsnapshot backup plan, 
write a script for downloading the docsets as part of this mirroring system.

###GitHub and BitBucket Issues Backups

This backup will take a little bit of time to develop, so make it when you are
regularly using issue tracking for the repo host. AKA, if you're not using it,
don't make the backup!

Centralized information is currently not being backed up. This is a good
candidate for a backup. Consider backing up the following items.

  JSON Data

  - Issues
  - Issue Comments
  - Milestones
  - Issue Labels / Compoenents

  Repos

  - Wikis

An ideal system would backup all the relevant JSON data at the time of the
backup while performing the same hard-linking that mirrors get. This would
help in case data gets corrupted and that corruption is backed up.

The latest backup is the most reliable and must be matched with
HEAD of the corresponding REPO - maybe store the hash of the latest commit for
that repo in an ID file at the backup root of the snapshot for easier association
to the repo.

Design of this "ideal" system still needs work, so don't implement anything
until something useful is fully formed.

