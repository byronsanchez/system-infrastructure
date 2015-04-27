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

Check the changes to the portage tree (-w performs a webrsync instead of an 
rsync):

    sudo eix-sync -w;

If there are news items, read them carefully:

    eselect news;

Securiy advisory check:

    glsa-check -t all;

Run updates

    emerge -DuvaN --with-bdeps=y world [--keep-going]

After update, read messages and perform any necessary tasks:

    less /var/log/portage/elog;

Post-updates

    emerge --usepkg=n @preserved-rebuild
    revdep-rebuild -- --usepkg=n
    perl-cleaner --all -- --usepkg=n
    python-updater -- --usepkg=n

Clean up (eclean will remove files that don't correspond to a package in the portage tree):

    emerge -av --depclean
    eclean distfiles
    eclean packages

Update configs if necessary and merge the updates with the puppet sources

    dispatch-conf;
    [Merge with puppet sources]
    emerge -u puppet-nitelite-development

Make updates available to clients:

    publish-gentoo-updates

Make sure compiler is properly set:

    gcc-config

# Client

Check the changes to the portage tree (-w performs a webrsync instead of an 
rsync):

    sudo eix-sync -w;

Run updates

    emerge -DuvaN --with-bdeps=y world [--keep-going]

Post-updates

    emerge @preserved-rebuild
    revdep-rebuild;
    perl-cleaner --all
    python-updater

Clean up (eclean will remove files that don't correspond to a package in the portage tree):

    emerge -av --depclean
    eclean distfiles
    eclean packages

Update configs through puppet (puppet gets updated through emerge):

  cd /etc/puppet
  ./init.sh
  puppet apply manifests/site.pp

# Additional tips

After you analyze the portage tree, check what can be upgraded. Show
dependencies so that you know why a package was pulled into the update list.

    emerge -Duvpt world;

Read logs and determine whether or not you really want to update the package.

    emerge -uvpl <package>;

IF YOU NEED TO UPDATE A LIST, use the following command so it doesn't go into
world file

    emerge -Duq1;

Get estimated merge time

    emerge -Duvp world | sudo genlop -p;

To check last merge time, run the command:

    sudo genlop -t1 --date 1 day ago;

