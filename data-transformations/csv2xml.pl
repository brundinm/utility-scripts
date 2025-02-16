#!/usr/bin/perl

# MRB -- Fri 18-Oct-2013

# Purpose: Perl script to convert a file from CSV to XML

# Description: Perl script to transform a field delimited CSV file into an XML
# file.  Each line in the input CSV file becomes a row element in the output
# XML file, and the header field names are used for the child element names
# for each data cell in a field in a row.  To run the script, type the following
# at the command prompt:

#     perl csv2xml.pl > output-file

# [This script adapted from a script located at this URL:
# http://laurentschneider.com/wordpress/2007/05/csv-with-xml-revisited.html]

# Note: check that the first line of the CSV file contains the header field names,
# with the field names separated by the appropriate field delimiter character

printf "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<root>\n";
our $indent = "    ";
our $indent2 = $indent . $indent;
$FS = "\t"; # MRB: set the field separator character, e.g., "\t"

open (F, "input.txt"); # MRB: set input-file 
@h = split($FS);

while (<F>) {
    if ($. == 1) {
        chomp;
        @h = split($FS);
        $NF = $#h
    }
    else {
        printf $indent . "<record>\n";
	    chomp;
        @Fld = split($FS);
        for ($i = 0; $i <= $NF; $i++) {
            printf $indent2 . "<%s>%s</%s>\n", $h[$i], $Fld[$i], $h[$i];
        }
        printf $indent . "</record>\n";
    }
}

printf "</root>\n";