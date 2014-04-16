###########################################
#                                         #
# MANAGED BY PUPPET                       #
#                                         #
# Manual changes WILL be overwritten      #
#                                         #
###########################################

server {
  listen 80;
  server_name binhost.internal.nitelite.io;

  access_log /var/log/nginx/binhost.access_log;
  error_log /var/log/nginx/binhost.error_log;

  root /srv/www/binhost.internal.nitelite.io;
  index index.php index.htm index.html;
  autoindex on;
  #error_page 404 = ;
}
