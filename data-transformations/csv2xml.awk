#!/usr/bin/awk -f

# MRB -- Fri 11-Oct-2013

# Purpose: AWK script to convert a file from CSV to XML

# Description: AWK script to transform a field delimited CSV file into an XML
# file.  Each line in the input CSV file becomes a row element in the output
# XML file, and the header field names are used for the child element names
# for each data cell in a field in a row.  To run the script, type the following
# at the command prompt:

#     awk -f csv2xml.awk input-file > output-file

# [This script adapted from a script located at this URL:
# http://ajhaupt.blogspot.ca/2013/02/how-to-xml-ify-tab-separated-text-file.html]

# Note: check that the first line of the CSV file contains the header field names,
# with the field names separated by the appropriate field delimiter character

BEGIN {
    FS = "\t" # MRB: set the field separator (FS) character, e.g., "\t"
}

NR == 1 {
    split($0, header, FS)
    printf "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<root>\n"
}

NR > 1 {
    indent = "    "
    indent2 = indent indent
    printf indent "<record>\n"
    for (i = 1; i <= NF; i++) {
        printf indent2 "<%s>%s</%s>\n", header[i], $i, header[i]
    }
    printf indent "</record>\n"
}

END {
    printf "</root>\n"
}