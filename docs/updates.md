# Updating Gentoo packages
#
# source: blog.yjl.im/2010/11/my-weekly-gentoo-update-process.html

Some notes regarding gentoo package updates. Updates will currently be done
manually. Once a significant amount of nodes are being managed, semi-automation
should be considered.

# Updating Gentoo

Try to stick to a regular weekly update process.

Run the following commands, one-by-one, analyze outputs and determine steps
based on the information you see.

# binhost
#
# source: http://forums.gentoo.org/viewtopic-t-976032-start-0.html

Start by syncing from external mirrors to local mirrors:

    /etc/cron.daily/mirror_gentoo

When rebuilding @preserved-rebuild:

    emerge --usepkg=n @preserved-rebuild

When doing revdep-rebuild:

    revdep-rebuild -- --usepkg=n

When doing perl-cleaner:

    perl-cleaner --all -- --usepkg=n

When doing python-updater:

    python-updater -- --usepkg=n

# general instructions

The following command is the equivalent to running:

    emerge --sync
    eix-update
    eix-diff

Check the changes to the portage tree
    sudo eix-remote update; # for adding overlays to the cache
    sudo eix-sync;

After you analyze the portage tree, check what can be upgraded. Show
dependencies so that you know why a package was pulled into the update list.

    emerge -Duvpt world;

If there are news items, read them carefully

    eselect news;

Securiy advisory check

    glsa-check;

Read logs and determine whether or not you really want to update the package.

    emerge -uvpl <package>;

IF YOU NEED TO UPDATE A LIST, use the following command so it doesn't go into
world file

    emerge -Duq1;

Get estimated merge time

    emerge -Duvp world | sudo genlop -p;

Update

    emerge -DuvaN --with-bdeps=y world

After update, read messages

    less /var/log/portage/elog;

Update configs if necessary and merge the updates with the puppet sources

    dispatch-conf;

To check last merge time, run the command:

    sudo genlop -t1 --date 1 day ago;

Also, don't forget to run the following command after updates:

    revdep-rebuild;

### Troubleshooting common problems

If you have perl-related problems because of a perl upgrade, make sure to run:

    perl-cleaner --all

Python package updates

    python-updater

If you have gcc problems after a gcc upgrade, make sure a compiler is properly
set by running:

    gcc-config

