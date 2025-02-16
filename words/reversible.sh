#!/bin/bash

# MRB: See https://unix.stackexchange.com/questions/269803/searching-usr-dict-words-to-find-words-with-certain-properties
rev $HOME/words/words-unix | grep -Fxf $HOME/words/words-unix | perl -l -ne '$dict{$_} = 1; END {foreach (keys %dict) {print if $dict{reverse($_)}}}' | sort

