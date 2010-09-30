locations = ['/Applications/DiffMerge.app/Contents/MacOS/DiffMerge']

import hashlib
import sys
import subprocess
import os
import shutil

def hashFile(filename):
  m = hashlib.md5()
  with open(filename) as f:
    m.update(f.read() + str(os.path.getmtime(filename)))
  return m.digest()

local = sys.argv[1]
base = sys.argv[2]
other = sys.argv[3]

validLocations = filter(os.path.exists, locations)
if len(validLocations) == 0:
  print("DiffMerge not found")
  sys.exit(1)
diffmerge = validLocations[0]

oldhash = hashFile(base)
# Works on Windows according to (IRC nick) Zephtar (orignial author)
#cmd = '"%s" "%s" "%s" "%s"' % (diffmerge, local, base, other)
# Works on OS X and Correct according to doc:
# http://docs.python.org/library/subprocess.html#subprocess.Popen
cmd = (diffmerge, base, local, other)
p = subprocess.Popen(cmd)
p.wait()
newhash = hashFile(base)

if oldhash == newhash:
  sys.exit(1)
else:
  shutil.copyfile(base, local)
  sys.exit(0)