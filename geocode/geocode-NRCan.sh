#!/usr/bin/sh

# MRB -- Sun 06-Apr-2014

# Purpose: Shell script to geocode place names using NRCan's CGNDB API

# Description: Shell script to geocode place names into their associated coordinates of
# latitude and longitude using Natural Resources Canada's (NRCan) Canadian Geographical
# Names Data Base (CGNDB) API.  The input file consists of place names for a particular
# province, with each place name appearing on a separate new line.  The output data returned
# from the server is in CSV format.  The resulting output file contains three comma-separated
# fields: place name, latitude, and longitude.  To run the script, type the following at the
# command prompt:

#     sh geocode-NRCan.sh

# Notes:
# * Geocode lookups using the CGNDB API can be done to a level of precision down to the
# locality (community place name).
# * To process the last record in the input file, a newline character needs to appear at the
# end of the record.
# * The CGNDB API does not have a limit on the number of geocode queries that can be performed.
# * Sample GET URL string: http://www.nrcan.gc.ca/earth-sciences/api?geoname=London&match=exact&conciseCode=CITY,TOWN,VILG,HAM,UNP&statusCode=A&regionCode=35&order=geoname&output=xml

# Useful documentation about the CGNDB API:
# * Application Programming Interface -- API: http://www.nrcan.gc.ca/earth-sciences/geography/place-names/data/9249
# * API parameters: https://www.nrcan.gc.ca/earth-sciences/geography/place-names/data/9251 
# * Search Place Names: http://www4.rncan.gc.ca/search-place-names/name.php

### Begin script
# set input file name
INPUT_FILE='input.csv'
# set output file name
OUTPUT_FILE='output.csv'
# set the MATCH parameter
MATCH='exact'
# set the CONCISE_CODE parameter
CONCISE_CODE='CITY,TOWN,VILG,HAM,UNP'
# set the STATUS_CODE parameter; A = current
STATUS_CODE='A'
# set the REGION_CODE parameter (province code); AB = 48, BC = 59, MB = 46, NB = 13, NL = 10,
# NT = 61, NS= 12, NU = 62, ON = 35, PE = 11, QC = 24, SK = 47, YT = 60
REGION_CODE=35
# set the ORDER parameter
ORDER='geoname'
# set the OUTPUT parameter (many output options, including "xml")
OUTPUT='csv'

# count the number of records to be processed and put this total in the TOTAL_RECORDS variable
TOTAL_RECORDS=`wc -l < $INPUT_FILE`
# initialize the RECORD_COUNT variable
RECORD_COUNT=0
# print out an initial batch geocoding statement
echo "### Begin the batch geocoding of" $TOTAL_RECORDS "place name records."

# loop through the INPUT_FILE records
while read PLACE_NAME
do
    # increment the FILE_COUNT number by 1
    RECORD_COUNT=`expr $RECORD_COUNT + 1`
    # print out a record processing statement
    echo "    Processing record number" $RECORD_COUNT "of" $TOTAL_RECORDS "records, the place name" $PLACE_NAME ". . ."
	# set the GEONAME parameter with the next PLACE_NAME value
	GEONAME="$PLACE_NAME"
	# query the CGNDB database, and write the results to tmp1
	wget -O - "http://www.nrcan.gc.ca/earth-sciences/api?geoname=""$GEONAME""&match="$MATCH"&conciseCode="$CONCISE_CODE"&statusCode="$STATUS_CODE"&regionCode="$REGION_CODE"&order="$ORDER"&output="$OUTPUT > tmp1
	# delete the header line in tmp1, and write the data line that remains to tmp2
	sed /geoname,status_term/d tmp1 > tmp2
	# extract latitude, and longitude, and write these strings to LAT_LNG
	LAT_LNG=`awk -F',' '{ print $5","$6 }' tmp2`
	if [ -n "$LAT_LNG" ]; then
	    # write place name, latitude, and longitude
	    echo "\""$PLACE_NAME"\","$LAT_LNG >> $OUTPUT_FILE
	else
	    # write error statement and place name
	    echo "\"Error: "$PLACE_NAME" was not geocoded\",," >> $OUTPUT_FILE
	fi
done < $INPUT_FILE

# delete temporary files
rm tmp1 tmp2

# print out a final batch geocoding statement
echo "### The batch geocoding of" $TOTAL_RECORDS "place name records is now finished."
### End script
