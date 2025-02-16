#!/bin/bash

# MRB -- Fri 08-May-2015

# Purpose: Shell script to look up the dictionary entry of a word using sdcv

printf "Enter a word to look up the dictionary entry of using sdcv: "
read word

sdcv $word
