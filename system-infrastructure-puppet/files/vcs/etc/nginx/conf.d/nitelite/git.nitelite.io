###########################################
#                                         #
# MANAGED BY PUPPET                       #
#                                         #
# Manual changes WILL be overwritten      #
#                                         #
###########################################

location / {
  if (-f $request_filename) {
    break;
  }

  if (!-f $request_filename) {
    rewrite ^/(.*)$ /cgit.cgi?url=$1 last;
    rewrite ^/$ /cgit.cgi last;
    break;
  }
}
