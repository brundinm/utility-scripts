#!/usr/bin/env python

# MRB -- Thu 05-Jun-2014

"""
Purpose:
    Convert a CSV file to a JSON file
Usage:
    python csv2json2.py data_file.csv
"""

import csv
import sys
import json

# Change each field name to the appropriate field name
fieldnames=["fieldname1","fieldname2","fieldname3"]

def convert(filename):
    csv_filename = filename[0]
    print "Opening CSV file: ",csv_filename 
    f=open(csv_filename, 'r')
    csv_reader = csv.DictReader(f,fieldnames)
    json_filename = csv_filename.split(".")[0]+".json"
    print "Saving JSON file: ",json_filename
    jsonf = open(json_filename,'w') 
    data = json.dumps([r for r in csv_reader])
    jsonf.write(data) 
    f.close()
    jsonf.close()

if __name__=="__main__":
    convert(sys.argv[1:])