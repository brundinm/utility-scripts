#!/bin/sh
# Usage: xml-format2.sh input.xml > output.xml
if [ -z "$1" ]
then
	echo Usage: xml-format2.sh input.xml \> output.xml
	exit
fi
xml fo -s 4 $1
