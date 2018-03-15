#! /bin/sh

test -f /usr/sbin/laptop_mode || exit 0

# lid button pressed/released event handler

/usr/sbin/laptop_mode auto

grep -q "closed" /proc/acpi/button/lid/LID/state 

if [ "$?" = 0 ];
then
	/usr/sbin/hibernate-ram
fi

