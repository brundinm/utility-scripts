@echo off
setlocal EnableDelayedExpansion

rem MRB -- Fri 10-Oct-2014

:: Purpose: Batch file to help solve crossword puzzles

:: Description: Batch file script that searches a newline-delimited list of dictionary words for a
:: user-supplied regular expression pattern.  To run the script, type the following at the command
:: prompt:

::     crossword.bat

set /p search_query=Please enter a word pattern to search for (use a . for unknowns, e.g., s...c..m): 

for /f "tokens=*" %%f in ('findstr /i /r "^%search_query%$" .\words-windows') do set search_results=!search_results! %%f

if "%search_query%"=="" (
    echo No word pattern was entered.
) else if "%search_results%"=="" (
    echo No matches were found for the word pattern "%search_query%".
) else (
    echo Word pattern matches:%search_results%
)
