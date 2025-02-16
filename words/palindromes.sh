#!/bin/bash

# MRB:See https://unix.stackexchange.com/questions/269803/searching-usr-dict-words-to-find-words-with-certain-properties
rev $HOME/words/words-unix | paste $HOME/words/words-unix - | sed -n 's/^\(.*\)\t\1$/\1/p' | perl -l -ne 'print if reverse($_) eq $_' $HOME/words/words-unix

