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

COMMAND_PREFIX="ssh rbackup@pg.internal.nitelite.io"

# roles
"${COMMAND_PREFIX}" "pg_dumpall -U postgres --globals-only postgres | pigz --rsyncable" > pgsql-roles-${DATE}.sql.gz
# schema only
"${COMMAND_PREFIX}" "pg_dump -U postgres --schema-only | pigz --rsyncable" > pgsql-schema-${DATE}.sql.gz
# data only
"${COMMAND_PREFIX}" "pg_dump -U postgres --data-only | pigz --rsyncable" > pgsql-data-${DATE}.sql.gz
# schema + info
"${COMMAND_PREFIX}" "pg_dump -U postgres | pigz --rsyncable" > pgsql-all-${DATE}.sql.gz

chmod 600 *.sql.gz

