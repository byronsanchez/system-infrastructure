# Notes


### dns

dns replication is just setting the confs right

### ldap

ldap replication is pretty simple. After initial migration, make sure conf files
are setup and it should work properly
  - add ldapreader user and give the replicant server access

ldapreader.ldif:

    dn: cn=ldapreader,dc=nitelite,dc=io
    userPassword: secret
    objectClass: organizationalRole
    objectClass: simpleSecurityObject
    cn: ldapreader
    description: LDAP reader used for synchronization

then run:

    ldapadd -x -W -D "cn=Manager,dc=nitelite,dc=io" -f ldapreader.ldif

### pgsql

pgsql replication is slightly trickier, but not really. just make sure conf
files are setup and prior to starting up the replicant server, run the
`sync_pgservers` script on the pgmaster node:

    psql -c "select pg_start_backup('initial_backup');"
    rsync -cva --inplace --exclude=*pg_xlog* /var/lib/postgresql/9.3/data/ slave_IP_address:/var/lib/postgresql/9.3/data/
    psql -c "select pg_stop_backup();"

This will copy the database from the master to the slave target. Both nodes need
to have the initial databases as the slave will only read the logs to figure out
future operations to perform (it doesn't build it from scratch)


### mysql

mysql replication is similar to pgsql, but slightly trickier to setup.

setup the master as normal. you can make the slave at anytime, even after the
master has lots of tables and data.

make sure the configs are right for both

try to avoid bin-do-db and all those filters. unless you absolutely know what
you're doing and why you need it, just avoid it.  see:
http://www.mysqlperformanceblog.com/2009/05/14/why-mysqls-binlog-do-db-option-is-dangerous/

Create a reader user on the master. Something like:

    GRANT REPLICATION SLAVE ON *.* TO 'slave_user'@'%' IDENTIFIED BY 'password';
    FLUSH PRIVILEGES;

then make sure to have 2 shells open to master

on shell 1, run

    FLUSH TABLES WITH READ LOCK;

leave this shell alone now! on shell 2 run:

    SHOW MASTER STATUS;

copy the data down (file and position)

on shell 2, exit the mysql prompt and run:

    mysqldump -u root -p --all-databases --master-data > dbdump.db

Once that's done, on shell 1 run:

    UNLOCK TABLES;
    QUIT;

scp/rsync the dump file to the slave

On the slave, install mysql and run mysql_install_db. Don't start mysql.

On gentoo, edit `/etc/conf.d/mysql` and set `MY_ARGS="--skip-slave-start=1"` 

start mysql

run:

    mysql -u root -p < /path/to/dbdump.db

when that's done, start a mysql prompt and run something like:

    CHANGE MASTER TO MASTER_HOST='MASTER_IP',MASTER_USER='myreader', MASTER_PASSWORD='myreaderpassword', MASTER_LOG_FILE='mysql-bin.FILE_NUMBER_HERE', MASTER_LOG_POS=  POSITION_NUMBER_HERE;

FILE_NUMBER_HERE == the file number from earlier's SHOW MASTER STATUS cmd (mysql.this_numberA
POSITION_NUMBER_HERE == the position number from earlier's SHOW_MASTER_STATUS)

stop mysql

edit `/etc/conf.d/mysql` and remove set `MY_ARGS=""`

start mysql.

enter mysql prompt

run:

    START SLAVE;
    SHOW SLAVE STATUS\G

it should be replicating!

NOTE: Do not leave slave off longer than the `expire_logs_days` for master. If
the master binlogs get scrubbed and the slave hasn't had a chance to replicate
it because it was off, those changes are gone. you'll have to do this again to
get the replication to match the master. otherwise, you should be able to turn
it off for less than that time, start it up and the slave will replicate from
where it left off.

this value actually defaults to 0 which means "no automatic removal"
see: https://dev.mysql.com/doc/refman/5.5/en/server-system-variables.html#sysvar_expire_logs_days



