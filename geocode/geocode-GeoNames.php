<?php

/**
 * MRB -- Sun 06-Apr-2014
 */

// Purpose: PHP script to geocode place names using the GeoNames Web Services API

/**
 * Description: PHP script to geocode place names into their associated coordinates of
 * latitude and longitude using the GeoNames Web Services API.  The input file consists of a
 * CSV text file with two fields, place name and 2-letter province/territory code, separated
 * by a comma, e.g., "Edmonton,AB", with each line in the text file containing these two
 * data elements.  The output data returned from the server is in XML format.  The resulting
 * output file contains three comma-separated fields: place name and 2-letter province/territory
 * code, latitude, and longitude.  To run the script, type the following at the command prompt:
 */
//     php geocode-GeoNames.php

# Notes:
# * Geocode lookups using the GeoNames Web Services API can be done to a level of precision
# down to the locality (community place name).
# * The GeoNames Web Services API has a limit of 2,000 requests per hour, and 30,000 requests
# per day.
# A GeoNames user account needs to be created; accounts can be created from this page:
# http://www.geonames.org/login  The user account username will then be used as the $username
# variable value.
# * Sample GET URL string: http://api.geonames.org/search?name_equals=London&adminCode1=08&country=CA&featureClass=P&type=XML&username=brundin
# * Sample GET URL string using unique GeoNames ID (e.g., London, ON: 6058560): http://ws.geonames.org/get?geonameId=6058560&username=brundin
# * Sample GET URL string to get map version: http://www.geonames.org/6058560/

# Useful documentation about the GeoNames Web Services API:
# * GeoNames Web Services Documentation: http://www.geonames.org/export/web-services.html
# * GeoNames Search Webservice: http://www.geonames.org/export/geonames-search.html

// set input file
$inputFile = "input.csv";
// set output file
$outputFile = "output.csv";
// set the GeoNames admin1 code parameter (province code): AB = 01, BC = 02, MB = 03, NB = 04,
// NL = 05, NT = 13, NS= 07, NU = 14, ON = 08, PE = 09, QC = 10, SK = 11, YT = 12
$adminCode1 = "11";
// set country code
$country = "CA";
// set GeoNames feature class
$featureClass = "P";
// set format type
$type = "xml";
// set username
$username = "brundin";

if (($handle = fopen("$inputFile.", "r")) !== FALSE) {
    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
        $placeName = $data[0];
        $provinceCode = $data[1];
        $name_equals = urlencode($placeName);
        $url = "http://api.geonames.org/search?name_equals=$name_equals&adminCode1=$adminCode1".
            "&country=$country&featureClass=$featureClass&type=$type&username=$username";
        $file = file_get_contents($url);
        $file = str_replace('xmlns=', 'ns=', $file);
        $xml = new SimpleXMLElement($file);
        $lat_array = $xml->xpath('/geonames/geoname/lat');
        $lng_array = $xml->xpath('/geonames/geoname/lng');
        $latitude = @$lat_array[0];
        $longitude = @$lng_array[0];
        if (isset($latitude) && isset($longitude)) {
            $newRow = "\"" . $placeName . "," . $provinceCode . "\"" . "," . $latitude .
		        "," . $longitude . "\n";
        }
        else {
            $newRow = "\"Error: " . $placeName . "," . $provinceCode . " was not geocoded\"" .
                "," . "," . "\n";
        }
        file_put_contents($outputFile, $newRow, FILE_APPEND);
    }
    fclose($handle);
}