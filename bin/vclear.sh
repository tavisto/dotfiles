#!/bin/bash
sudo /sbin/service varnish stop && sudo rm -f /var/lib/varnish/varnish_storage.bin && sudo /sbin/service varnish start