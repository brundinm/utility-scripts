#!/bin/bash

# MRB -- Wed 29-Apr-2015

# Purpose: Shell script to check the spelling of a word using Aspell

printf "Please enter a word to check the spelling of using Aspell: "
read word

echo $word | aspell -a

