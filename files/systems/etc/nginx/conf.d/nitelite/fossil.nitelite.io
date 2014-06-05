###########################################
#                                         #
# MANAGED BY PUPPET                       #
#                                         #
# Manual changes WILL be overwritten      #
#                                         #
###########################################

location = / {
  include      uwsgi_params;
  uwsgi_param REDIRECT_STATUS 200; # required by php 5.3
  uwsgi_modifier1 9;
  uwsgi_pass   fossil.internal.nitelite.io:3128;
  rewrite      ^/(.*)$ /cgi-bin/index.cgi break;
}
