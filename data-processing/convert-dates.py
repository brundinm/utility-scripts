#!/usr/bin/env python

# convert Apache log file date-time format of DD/MM/YYYY:hh:mm:ss to
# ISO 8601 date-time format of YYYY-MM-DD hh:mm:ss
# run program using this command:
# python convert-dates.py > input-file.txt

import sys
import re


months = {'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec' : '12'}
regex = re.compile("(\d{2})/(\w+)/(\d{4}):(\d{2}):(\d{2}):(\d{2})",re.IGNORECASE)
for line in sys.stdin:
    try:
        r = regex.search(line)
        g = r.groups()
        print g[2] + '-' + months[g[1]] + '-' + g[0] + ' ' + g[3] + ':' + g[4] + ':' + g[5]
    except:
        pass
