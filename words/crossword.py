#!/usr/bin/env python

# MRB -- Fri 10-Oct-2014

# Purpose: Python script to help solve crossword puzzles

# Description: Python script that searches a newline-delimited list of dictionary words for a
# user-supplied word pattern.  To run the script, type the following at the command prompt:

#     python crossword.py

search_query = raw_input('Please enter a word pattern to search for (use a . for unknowns, e.g., s...c..m): ')

f = open('words-unix', 'r')
search_results = ''

for line in f:
    line = line.strip()
    if len(line) == len(search_query):
        good = 1
        pos = 0
        for letter in search_query:
            if not letter == '.':
                if not letter.lower() == line.lower()[pos]:
                    good = 0
            pos += 1
        if good == 1:
            search_results = search_results + ' ' + line
f.close()

if search_query == '':
    print 'No word pattern was entered.'
elif search_results == '':
    print 'No matches were found for the word pattern ' + '"' + search_query + '".'
else:
    print 'Word pattern matches:' + search_results
