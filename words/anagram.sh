#!/bin/bash

# MRB: See https://www.cs.uic.edu/~sma/Miscellany/EveryWordCheater/
# Find anagrams by typing in string; compares string to word list of anagrams
# in the file "anagram.txt", and prints out all the sub-words in
# ascending order of the word length; to run, type the following:
#
# sh anagram.sh
#
# Note: if there are any anagrams that use all of the letters of the word,
# they will be listed at the bottom of the returned list along with the 
# search word, and they will be of the same string length as the search
# word

printf "Please enter a word to search for anagram sub-words for: "

read search_anagram

for word in `python everyword.py $search_anagram`;do cat anagram.txt | grep -w $word | awk '{for(i=2;i<=NF;i++)print $i}'; done | awk '{print length, $0}' | sort -n | awk '{$1="";print $0}'

