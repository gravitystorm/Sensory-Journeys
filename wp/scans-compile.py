#!/usr/bin/python
# -*- coding: utf-8 -*-

# Compiles all scans into one resultant layer, in the all/ directory
# run this from the wp/ directory

import os, shutil, sys
from PIL import Image
import psycopg2

import dbconnect

base = os.path.join(os.path.dirname(__file__) , "site", "www", "files", "scans")

def composite(base, scan, target):
  print "\nCompositing %s onto %s" % (scan, target)
  for zoom in os.listdir(os.path.join(base, scan)):
    if os.path.isdir(os.path.join(base, scan, zoom)):
      #print zoom
      for x in os.listdir(os.path.join(base, scan, zoom)):
        for y in os.listdir(os.path.join(base, scan, zoom, x)):
          if os.path.exists(os.path.join(base, target, zoom, x, y)): #blend the tiles together
            im = Image.open(os.path.join(base, target, zoom, x, y))
            im2 = Image.open(os.path.join(base, scan, zoom, x, y))
            im.paste(im2, None, im2)
            im.save(os.path.join(base, target, zoom, x, y))
            sys.stdout.write(".")
            sys.stdout.flush()
          else: #copy the file over as-is
            try:
              os.makedirs(os.path.join(base, target, zoom, x))
            except:
              pass #directory already exists
            shutil.copy(os.path.join(base, scan, zoom, x, y), os.path.join(base, target, zoom, x))
            sys.stdout.write("C")
            sys.stdout.flush()
            
conn = psycopg2.connect(dbconnect.dbconnection)
cur = conn.cursor()

cur.execute("select id from projects")
projects = cur.fetchall()

for project in projects:

  # composite all scans
  cur.execute("Select scan_id from shadow_scans where project_id = %i" % project[0])
  scans = cur.fetchall()
  all = "composite/%i/all" % project[0]
  try: # try removing the existing output, if any
    shutil.rmtree(os.path.join(base, all)) 
  except:
    pass
  for scan in scans:
    composite(base, scan[0], all)

  # composite each mode
  cur.execute("Select distinct mode_id from shadow_scans where project_id = %i" % project[0])
  modes = cur.fetchall()
  for mode in modes:
    if mode[0] is None: # if there are no scans with modes, there will be one SQL result of (None,)
      continue
    mode_path = "composite/%i/mode_%i" % (project[0], mode[0])
    try:
      shutil.rmtree(os.path.join(base, mode_path))
    except:
      pass
    cur.execute("select scan_id from shadow_scans where project_id = %i and mode_id = %s" % (project[0], mode[0]))
    scans = cur.fetchall()
    for scan in scans:
      composite(base, scan[0], mode_path)

