#!/bin/sh

###########################################
#                                         #
# MANAGED BY PUPPET                       #
#                                         #
# Manual changes WILL be overwritten      #
#                                         #
###########################################

umask 0077

DATE="$( date +%Y%m%d%H%M )"

COMMAND_PREFIX="ssh rbackup@ldap.internal.nitelite.io"

# the config database. not currently used in favor of slapd.conf
#slapcat -v -n 0 -l "ldap-slapd-config-${DATE}.ldif";
"${COMMAND_PREFIX}" "slapcat -v -n 1 | pigz --rsyncable" > ldap-all-${DATE}.ldif.gz

chmod 600 *.ldif.gz

