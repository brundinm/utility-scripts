#!/usr/bin/awk -f

# MRB -- Fri 18-Oct-2013

# Purpose: AWK script to process GeoNames data

# Description: AWK script to loop through a CSV code file and create a
# key-value pairs hash using two fields in each row, and then use these
# key-value pairs to process a second input CSV file, globally searching
# and replacing the keys with their corresponding values, and then
# writing this out to a new third CSV output file.  To run the script,
# type the following at the command prompt:

#     awk -f search-replace.awk code-file input-file output-file

# [This script adapted from a script located at this URL:
# http://magvar.wordpress.com/2011/05/18/awking-it-how-to-load-a-file-into-an-array-in-awk/]

# MRB: Note: to process the GeoNames data, this script needs to be run six
# times, to process the six different GeoNames variable code (key-value)
# files: (1) admin2Code, 2) admin1Code, (3) countryCode, (4) featureCode,
# (5) featureClass, and (6) timezone

#### MRB: GeoNames: names for code, input, and output files ####
# (1) admin2Code: code_file: admin2Codes.txt; input_file: places.txt; output_file: places1.txt
# (2) admin1Code: cod_file: admin1CodesASCII.txt; input_file: places1.txt; output_file: places2.txt
# (3) countryCode: code_file: countryInfo.txt; input_file: places2.txt; output_file: places3.txt
# (4) featureCode: code_file: featureCodes_en.txt; input_file: places3.txt; output_file: places4.txt
# (5) featureClass: code_file: featureClasses.txt; input_file: places4.txt; output_file: places5.txt
# (6) timezone: code_file: timeZones.txt; input_file: places5.txt; output_file: places6.txt

BEGIN {
    FS = "\t" # MRB: set the field separator (FS) character, e.g., "\t"
    OFS = "\t" # MRB: set the output field separator (OFS) character, e.g., "\t"
    code_file = "index.txt" # MRB: set CSV code file that contains key-value pairs
    input_file = "data.txt" # MRB: set CSV input file that contains keys that need to be replaced with values
    output_file = "output.txt" # MRB: set CSV output file
}

{
    while (getline < code_file) {
        split($0, fields)
        # key = fields[1]
        # value = fields[2]
        # key_value[key] = value

        #### MRB: GeoNames: array index numbers for keys and values ####
        # (1) admin2Code: key: 1; value: 2
        # (2) admin1Code: key: 1; value: 2
        # (3) countryCode: key: 1; value: 5
        # (4) featureCode: key: 1; value: 2
        # (5) featureClass: key: 1; value: 2
        # (6) timezone: key: 2; value: 3
  
        # MRB: set element key-value pairs for the code_file; to the left of
        # the assignment operator is the key index field, and to the right of the
        # assignment operator is the value index field

        key_value[fields[1]] = fields[2]
    }
    close(code_file)

    while (getline < input_file) {
        split($0, sr)

        #### MRB: GeoNames: array index numbers for substituting the value and matching the key ####
        # (1) admin2Code: sub value: 12; match key: 9 and 11 and 12 [three fields concatenated, separated by periods]
        # (2) admin1Code: sub value: 11; match key: 9 and 11 [two fields concatenated, separated by a period]
        # (3) countryCode: sub value: 9; match key: 9 [one field]
        # (4) featureCode: sub value: 8; match key: 7 and 8 [two fields concatenated, separated by a period]
        # (5) featureClass: sub value: 7; match key: 7 [one field]
        # (6) timezone: sub value: 18; match key: 18 [one field]
	   
        # MRB: set index fields for the substitution of the hash value for the key or
        # the partial key in the new output_file; to the left of the assignment
        # operator is the index field in the output_file that will be substituted
        # with the hash value, and to the right of the assignment operator is the
        # index field string or concatenated index fields string in the output_file
        # that matches the key; use the appropriate one field, two fields, or three
        # line below, and comment the other two lines out
        # print sr[1]"."sr[2] # MRB: error debugging to see if key is correct
	   
        # $9 = key_value[sr[9]] # one field matches key
        $2 = key_value[sr[1]"."sr[2]] # two fields concatenated with a period matches key
        # $12 = key_value[sr[9]"."sr[11]"."sr[12]] # three fields concatenated with periods matches key

        print > output_file
    }

}