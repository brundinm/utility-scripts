#!/bin/sh
# Usage: xml-format.sh input.xml > output.xml
if [ -z "$1" ]
then
	echo Usage: xml-format.sh input.xml \> output.xml
	exit
fi
XMLLINT_INDENT='    ' xmllint --format $1
