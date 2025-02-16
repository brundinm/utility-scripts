#!/usr/bin/env python

# MRB -- Sun 06-Apr-2014

# Purpose: Python script to geocode place names using the Google Geocoding API

# Description: Python script to geocode place names into their associated coordinates of
# latitude and longitude using the Google Geocoding API.  The input file consists of a CSV
# text file with two fields, place name and 2-letter province/territory code, separated
# by a comma, e.g., "Edmonton,AB", with each line in the text file containing these two
# data elements.  The output data returned from the server is in JSON format.  The resulting
# output file contains three comma-separated fields: place name and 2-letter province/territory
# code, latitude, and longitude.  To run the script, type the following at the command prompt:

#     python geocode-Google.py

# [This script adapted from a script located at this URL:
# http://fredgibbs.net/tutorials/extract-geocode-placenames-from-text-file/]

# Notes:
# * Geocode lookups using the Google Geocoding API can be done to a level of precision
# down to the street address -- the street address just needs to be added before the
# community name, separated by a comma.  For example, for Strathcona Public Library,
# it would be the following: 8331 104 Street,Edmonton,AB  Addresses with multiple parts
# can also be geocoded -- just add the multiple parts each separated by a comma, as in the
# following example: 4-20 Humanities Centre,University of Alberta,Edmonton,AB
# * A dash can appear between the street address and the street name.
# * The Google Geocoding API has a limit of 2,500 requests per 24 hour period.
# * A Google API key is required to query the API using a Google record's place_id value;
# * information about the Google API key can be found here https://developers.google.com/api-client-library/python/guide/aaa_apikeys
# * and an API key can be created from the Google Developers Console located here https://console.developers.google.com/
# * Sample GET URL string: http://maps.googleapis.com/maps/api/geocode/xml?address=London,ON&sensor=false
# * Sample GET URL string (another version): http://www.google.ca/maps/api/geocode/xml?address=London,%20ON
# * Sample GET URL string to get map version: https://www.google.ca/maps/place/London,%20ON
# * Sample GET URL string using API key (AIzaSyBnKE7aZSWodIiAUEGZ1LL4WPJmshtDUnc):
# https://maps.googleapis.com/maps/api/geocode/xml?address=London,ON&sensor=false&key=AIzaSyBnKE7aZSWodIiAUEGZ1LL4WPJmshtDUnc
# * Sample GET URL string using unique place_id (e.g., London, ON: ChIJC5uNqA7yLogRlWsFmmnXxyg) and API key (AIzaSyBnKE7aZSWodIiAUEGZ1LL4WPJmshtDUnc):
# https://maps.googleapis.com/maps/api/geocode/xml?place_id=ChIJC5uNqA7yLogRlWsFmmnXxyg&sensor=false&key=AIzaSyBnKE7aZSWodIiAUEGZ1LL4WPJmshtDUnc

# Useful documentation about the Google Geocoding API:
# * The Google Geocoding API: https://developers.google.com/maps/documentation/geocoding/

import requests
import csv

inputfile = open('input.csv','r')
outputfile = csv.writer(open('output.csv','wb'))

for row in inputfile:
    row = row.rstrip()
    url = 'http://maps.googleapis.com/maps/api/geocode/json'
    payload = {'address':row, 'sensor':'false'}
    r = requests.get(url, params=payload)
    json = r.json()

    try:
        lat = json['results'][0]['geometry']['location']['lat']
        lng = json['results'][0]['geometry']['location']['lng']

        newrow = [row,lat,lng]
        outputfile.writerow(newrow)
    except IndexError:
        errorrow = ['Error: '+row+' was not geocoded','','']
        outputfile.writerow(errorrow)