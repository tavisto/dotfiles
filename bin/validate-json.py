#!/usr/bin/env python
# -*- coding: UTF-8 -*-
""" Small script to parse a json file and validate it """
from optparse import OptionParser

try:
    import json
except ImportError:
    import simplejson as json

PARSER = OptionParser()
(OPTIONS, ARGS) = PARSER.parse_args()
for FILENAME in ARGS:
    try:
        FILE = open(FILENAME)
        json.load(FILE)
        print("Valid: %s" % FILENAME )
    except Exception, details:
        print("Not Valid: %s", details)
