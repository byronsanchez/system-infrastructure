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
COMMAND_PREFIX="ssh rbackup@my.internal.nitelite.io"

# schema only
${COMMAND_PREFIX} "mysqldump --all-databases --lock-all-tables --routines --events --triggers --no-data --force | pigz --rsyncable" > mysql-schema-${DATE}.sql.gz
# data only
${COMMAND_PREFIX} "mysqldump --all-databases --lock-all-tables --skip-triggers --no-create-info --no-create-db --force | pigz --rsyncable" > mysql-data-${DATE}.sql.gz
# schema + info
${COMMAND_PREFIX} "mysqldump --all-databases --lock-all-tables --routines --events --triggers --force | pigz --rsyncable" > mysql-all-${DATE}.sql.gz

chmod 600 *.sql.gz

