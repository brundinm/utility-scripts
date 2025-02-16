#!/usr/bin/awk -f

# anagram.awk --- An implementation of the anagram-finding algorithm
#                 from Jon Bentley's "Programming Pearls," 2nd edition.
#                 Addison Wesley, 2000, ISBN 0-201-65788-0.
#                 Column 2, Problem C, section 2.8, pp 18-20.

# MRB: See https://www.gnu.org/software/gawk/manual/html_node/Anagram-Program.html
# This script finds anagrams in a word list.  For example, to find anagrams
# in the word list "words-unix", use the following command:
# 
# gawk -f anagram.awk ./words-unix > all-anagrams.txt
#
# To find all anagrams for words beginning with a "b", type the following:
#
# gawk -f anagram.awk ./words-unix | grep -i '^b'
#
# To find all anagrams for the word "breaks", type the following:
#
# gawk -f anagram.awk ./words-unix | grep -i ' breaks '

# MRB: set IGNORECASE to a nonzero value so regexp and string operations
#      ignore case (IGNORECASE is a gawk extension)
#IGNORECASE = 1

/'s$/   { next }        # Skip possessives

{
    key = word2key($1)  # Build signature
    data[key][$1] = $1  # Store word with signature
}

# word2key --- split word apart into letters, sort, and join back together

function word2key(word,     a, i, n, result)
{
    n = split(word, a, "")
    asort(a)

    for (i = 1; i <= n; i++)
        result = result a[i]

    return result
}

END {
    sort = "sort"
    for (key in data) {
        # Sort words with same key
        nwords = asorti(data[key], words)
        if (nwords == 1)
            continue

        # And print. Minor glitch: trailing space at end of each line
        for (j = 1; j <= nwords; j++)
            printf("%s ", words[j]) | sort
        print "" | sort
    }
    close(sort)
}

