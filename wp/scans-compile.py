#!/usr/bin/python
# -*- coding: utf-8 -*-

# Compiles all scans into one resultant layer, in the all/ directory
# run this from the wp/ directory

import os, shutil, sys
from PIL import Image

base = os.path.join(os.getcwd(), "site", "www", "files", "scans")
#base = "/home/andy/src/sustrans/wp/site/www/files/scans/"
#base = "/home/andy/temp/sustrans/scans/"
#path, scans, = os.walk(path)


all = "all"

try:
  shutil.rmtree(os.path.join(base, all))
except:
  pass

for scan in os.listdir(base):
  print "\n %s" % scan
  if scan == "all":
    continue
  if os.path.isdir(os.path.join(base, scan)):
    for zoom in os.listdir(os.path.join(base, scan)):
      if os.path.isdir(os.path.join(base, scan, zoom)):
        #print zoom
        for x in os.listdir(os.path.join(base, scan, zoom)):
          for y in os.listdir(os.path.join(base, scan, zoom, x)):
            if os.path.exists(os.path.join(base, all, zoom, x, y)): #blend the tiles together
              im = Image.open(os.path.join(base, all, zoom, x, y))
              im2 = Image.open(os.path.join(base, scan, zoom, x, y))
              im.paste(im2, None, im2)
              im.save(os.path.join(base, all, zoom, x, y))
              sys.stdout.write(".")
              sys.stdout.flush()
            else: #copy the file over as-is
              try:
                os.makedirs(os.path.join(base, all, zoom, x))
              except:
                pass #already exists
              shutil.copy(os.path.join(base, scan, zoom, x, y), os.path.join(base, all, zoom, x))
              sys.stdout.write("C")
              sys.stdout.flush()