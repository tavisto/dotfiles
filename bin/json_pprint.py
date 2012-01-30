#!/usr/bin/env python
import json
import pprint
import optparse

parser = optparse.OptionParser("usage: %prog [options]", conflict_handler="resolve")
(options, args) = parser.parse_args()
print json.dumps(json.load(open(args.pop())), indent=4)