###########################################
#                                         #
# MANAGED BY PUPPET                       #
#                                         #
# Manual changes WILL be overwritten      #
#                                         #
###########################################

server {
  server_name  www.stage.hackbytes.com;
  rewrite ^(.*) http://stage.hackbytes.com$1 permanent;
}

server {
  listen 80;
  server_name stage.hackbytes.com;

  access_log /var/log/nginx/hackbytes.access_log;
  error_log /var/log/nginx/hackbytes.error_log;

  root /srv/www/hackbytes.com/current/_site;
  index index.php index.htm index.html;
  error_page 404 = /assets/path.php;

  # Pass all .php files onto a php-fpm/php-fcgi server.
  location ~ \.php$ {
    # Zero-day exploit defense.
    # http://forum.nginx.org/read.php?2,8845,page=3
    # Won't work properly (404 error) if the file is not stored on this server
    # which is entirely possible with php-fpm/php-cgi.
    # Comment the 'try_files' line out if you set up php-fpm/php-fcgi on
    # another machine.  And then cross your fingers that you won't get hacked.
    try_files $uri =404;
 
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    include fastcgi_params;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    #fastcgi_intercept_errors on;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
  }
}
