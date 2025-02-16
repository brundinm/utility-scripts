#!/usr/bin/env python

# MRB -- Thu 05-Jun-2014

"""
Purpose:
    Convert a CSV file to a JSON file
Usage:
    python csv2json.py
"""

import csv
import json

# Change to the appropriate input CSV file
f = open( 'input_file.csv', 'rU' )
# Change each field name to the appropriate field name
reader = csv.DictReader( f, fieldnames = ( "fieldname1","fieldname2","fieldname3"))
out = json.dumps( [ row for row in reader ] )
print "JSON file parsed"
# Change to the appropriate output JSON file
f = open( 'output_file.json', 'w')
f.write(out)
print "JSON file saved"