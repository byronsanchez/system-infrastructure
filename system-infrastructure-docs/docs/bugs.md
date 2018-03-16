### wrong umask 002 instead of 022

- default system umask of 022 is overwritten by 002, resulting in 0775 for dirs 
  instead of 0755.
- can be caused when rvm is sourced in a screen session.
- rvm bug?
- temporary fix is to manually set umask after sourcong rvm
