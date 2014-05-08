Memory and disk allocations for local guests - minimum amount of memory for setting up
base systems on the network. Since I use it for my own work, I can keep things
as low as possible. Note that all nodes contain base services (postfix clients
that talk to the mail server, syslog, and other base daemons) so these need to
be accounted for as well.

**Default to 256MB unless more is definitely needed. If optimizations are
absolutely required, use the following as a guide.**

512MB 2 cores, 50GB

webserver

256MB 1 core, 20GB

dns
ldap
proxy
mysql
pgsql
mail

128MB 1 core, 10GB

none

