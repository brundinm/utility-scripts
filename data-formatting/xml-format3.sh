#!/bin/sh

# normalize and join the file, and then format and indent four spaces
sed 's/^[ \t]*//;s/[ \t]*$//' $1 | tr '\n' ' ' | XMLLINT_INDENT='    ' xmllint --format -
