if test -r /etc/profile; then
	. /etc/profile
fi

test -x /etc/X11/Xsession && exec /etc/X11/Xsession
exec /bin/sh /etc/X11/Xsession#!/bin/sh

if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG 
fi

# Default
#. /etc/X11/Xsession

# XFCE
startxfce4