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
[ -e "$HOME/.rvm/bin" ] && export PATH="$PATH:$HOME/.rvm/bin"
