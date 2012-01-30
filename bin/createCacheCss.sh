#!/bin/bash

CDN_URL='https://ak-secure-beatport.bpddn.com'

ORIG=$1
DEST=$2
echo "Translating all image paths to $CDN_URL \n"
cat $ORIG | sed "s#/images#$CDN_URL/images#" > $DEST

