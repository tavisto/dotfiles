#!/bin/bash

sudo unlink /usr/lib/flashplugin-installer/libflashplayer.so
if [ $1 == 'debug' ]
then
  #sudo ln -s /usr/lib/flashplugin-installer/libflashplayer-9-debug.so /usr/lib/flashplugin-installer/libflashplayer.so
  sudo ln -s /usr/lib/flashplugin-installer/libflashplayer-10-debug.so /usr/lib/flashplugin-installer/libflashplayer.so
  echo "Installed debug version"
else
  sudo ln -s /usr/lib/flashplugin-installer/libflashplayer-10.so /usr/lib/flashplugin-installer/libflashplayer.so
  echo "Installed non debug version"
fi

ls -l /usr/lib/flashplugin-installer/
