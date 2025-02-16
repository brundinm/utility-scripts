#!/bin/bash

# MRB -- Fri 10-Oct-2014

# Purpose: Shell script to help solve crossword puzzles

# Description: Shell script that searches a newline-delimited list of dictionary words for a
# user-supplied regular expression pattern.  To run the script, type the following at the command
# prompt:

#     sh crossword.sh

printf "Please enter a word pattern to search for (use a . for unknowns, e.g., s...c..m): "
read search_query

search_results=`grep -i ^$search_query$ ./words-unix`

if [ "$search_query" = "" ]; then
    echo "No word pattern was entered."
elif [ "$search_results" = "" ]; then
    echo "No matches were found for the word pattern" \"$search_query\""."
else
    echo "Word pattern matches:" $search_results
fi
