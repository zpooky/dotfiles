#!/usr/bin/env bash

OUT=$HOME/.Xdbus

touch $OUT
chmod 600 $OUT
env | grep DBUS_SESSION_BUS_ADDRESS > $OUT
echo 'export DBUS_SESSION_BUS_ADDRESS' >> $OUT
