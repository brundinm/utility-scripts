#!/usr/bin/python
# Usage: json-format.py input-file.json > output-file.json
import fileinput
import json
print json.dumps( json.loads(''.join([line.strip() for line in fileinput.input()])), sort_keys=True, indent=4)
