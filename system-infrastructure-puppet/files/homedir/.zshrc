###########################################
#                                         #
# MANAGED BY PUPPET                       #
#                                         #
# Manual changes WILL be overwritten      #
#                                         #
###########################################

# Load NVM
[ -e "${HOME}/.nvm/nvm.sh" ] && source ${HOME}/.nvm/nvm.sh

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# nodejs for users using nodejs
export PATH="$PATH:$HOME/.nodejs/bin"

# locale settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
