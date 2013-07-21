#!/usr/bin/env bash
echo "Clearing Cache"
dscacheutil -flushcache
sleep 3
echo "Restarting mDNSResponder"
sudo killall -HUP mDNSResponder
