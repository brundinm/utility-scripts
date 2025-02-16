#!/usr/bin/python

# MRB: Tue 26-Sep-2017
# Written by Ron Hubbard
# Code came from Ron Hubbard's Blog
# See https://rhubbarb.wordpress.com/2009/11/21/anagrams/

# To run this Python script, create an empty directory, put the script
# in the empty directory, and put any word lists or dictionary files
# in this directory as well, and name the word lists or dictionary
# files so that they have a ".txt" extension, e.g., "words-unix.txt";
# then just type "python words-data.py > words-data" in the directory,
# and the script will load and read any of the word lists or dictionary
# files and output the data to the file "words -data"; can then later
# rename the "words-data" file to "words-data.txt"

import os

def process (data, filename):
        print filename
        f = open (filename)
        if f:
                wordlist = f.readlines()
                f.close()

                find_palindromes (data['palindromes'], wordlist)
                find_reversibles (data['reversibles'], wordlist)
                find_multiple_anagram (data['anagrams'], wordlist)
                find_ups_and_downs (data['ordered'], wordlist)

def find_palindromes (data, wordlist):

        for wordentry in wordlist:
                wordentry = wordentry.split()[0]
                if wordentry == wordentry [::-1]:
                        data[wordentry] = None

def find_reversibles (data, wordlist):

        words = {}
        for wordentry in wordlist:
                wordentry = wordentry.split()[0]
                rev_wordentry = wordentry [::-1]
                if rev_wordentry in words:
                        data[rev_wordentry] = None
                words[wordentry] = None

def all (function, l):
        for e in l:
                if not function (e):
                        return False
        return True

def find_multiple_anagram (data, wordlist):

        words = {}
        for wordentry in wordlist:
                wordentry = wordentry.split()[0]

                wordlo = wordentry.lower()
                wordletters = list(wordlo)

                if wordentry == wordlo and all (lambda s : s.isalpha(), wordletters):

                        wordletters.sort()
                        wordletters = ''.join(wordletters)

                        if wordletters not in words:
                                words[wordletters] = []
                        words[wordletters].append(wordentry)

        for (wordletters, wordlist) in words.iteritems():
                if len(wordlist) >= 3:
                        data[((len(wordlist), len(wordlist[0])), wordletters)] = wordlist

def uniq (l):
        u = []
        if l:
                u = [l.pop(0)]
                while l:
                        e = l.pop(0)
                        if e != u[-1]:
                                u.append(e)
        return u

def find_ups_and_downs (data, wordlist):

        words = {}
        for wordentry in wordlist:
                wordentry = wordentry.split()[0]

                wordlo = wordentry.lower()
                revwordlo = wordlo[::-1]

                wordletters = filter(lambda s : s.isalpha(), list(wordlo))
                wordletters.sort()
                wordletters = uniq (wordletters)
                wordletters = ''.join(wordletters)

                if len (wordentry) >= 4:
                        if wordentry == wordlo:
                                if wordletters == wordlo:
                                        data[wordentry] = '+'
                                elif wordletters == revwordlo:
                                        data[wordentry] = '-'


if __name__ == '__main__':

        data = {
                'palindromes' : {},
                'reversibles' : {},
                'anagrams' : {},
                'ordered' : {},
        }

        for filename in os.listdir('.'):
                if os.path.isfile(filename):
                        (filebase, fileext) = os.path.splitext(filename)
                        if fileext == '.txt' and '.stdout.' not in filename:
                                process (data, filename)

        print
        print 'Palindromes:'
        words = data['palindromes'].keys()
        words.sort()
        for word in words:
                print '\t' + word

        print
        print 'Reversibles:'
        words = data['reversibles'].keys()
        words.sort()
        for word in words:
                print '\t' + word + ' / ' + word[::-1]

        print
        print 'Multiple anagrams:'
        words = data['anagrams'].keys()
        words.sort()
        for (length, wordletters) in words:
                wordlist = data['anagrams'][(length, wordletters)]
                print '\t' + str(length), repr(wordlist)

        print
        print 'Upwords and Downwords:'
        words = data['ordered'].keys()
        words.sort()
        for word in words:
                print '\t' + data['ordered'][word], word

        print

