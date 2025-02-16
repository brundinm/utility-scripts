#!/bin/sh
# Usage: json-format.sh input.json > output.json
if [ -z "$1" ]
then
	echo Usage: json-format.sh input.json \> output.json
	exit
fi
python -mjson.tool $1
