#!/bin/sh
if [ ! -f $1 ]; then
    echo "Usage: $0 "
    exit
fi
echo "Sorting $1"
sort -t ' ' -k 5.9,5.12n -k 5.5,5.7M -k 5.2,5.3n -k 5.14,5.15n -k 5.17,5.18n -k 5.20,5.21n $1 > $2
