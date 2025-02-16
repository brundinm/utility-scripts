#!/usr/bin/perl -w

# MRB -- Sun 06-Apr-2014

# Purpose: Perl script to geocode place names using the gecoder.ca API

# Description: Perl script to geocode place names into their associated coordinates of
# latitude and longitude using the geocoder.ca API.  The input file consists of a CSV
# text file with two fields, place name and 2-letter province/territory code, separated
# by a comma, e.g., "Edmonton,AB", with each line in the text file containing these two
# data elements.  The output data returned from the server is in XML format.  The resulting
# output file contains three comma-separated fields: place name and 2-letter province/territory
# code, latitude, and longitude.  To run the script, type the following at the command prompt:

#     perl geocode-geocoder.ca.pl input.csv > output.csv

# [This script adapted from a script located at this URL:
# http://geocoder.ca/?premium_api=1]

# Notes:
# * Geocode lookups using the geocoder.ca API can be done to a level of precision
# down to the street address -- the street address just needs to be added before the
# community name, separated by a comma.  For example, for Strathcona Public Library,
# it would be the following: 8331 104 Street,Edmonton,AB  Addresses with multiple parts
# can also be geocoded -- just add the multiple parts each separated by a comma, as in the
# following example: 4-20 Humanities Centre,University of Alberta,Edmonton,AB
# * Do not put a dash between the street address and the street name, as this will cause the
# query to fail.
# * The geocoder.ca API has a limit in the range of 500-2,000 lookups per day (varies
# according to server load).
# * Sample GET URL string: http://geocoder.ca/?&locate=London,ON&geoit=XML

# Useful documentation about the geocoder.ca API:
# * API: http://geocoder.ca/?premium_api=1

use strict;
use warnings;

my $file = $ARGV[0] or die "Need to set input CSV file on the command line\n";
 
open(my $data, '<', $file) or die "Could not open '$file' $!\n";
 
while (my $address = <$data>) {
    chomp $address;

    my %data;
    my $url = "http://geocoder.ca" . "/?" . "&locate=" . $address . "&geoit=XML";
    use LWP::UserAgent;
    my $ua = new LWP::UserAgent;
    $ua->agent("mrb/0.1 " . $ua->agent);
    my $req = new HTTP::Request('GET', $url);
    $req->header(Subject => 'XML Get',
             From    => 'nospam@nospam.ca',
             timeout => '3*10');
    my $res = $ua->request($req);
    if ($res->is_success) {
        my $result = $res->content;
        if ($result =~ /<latt>(.*)<\/latt>/) {
            $data{latt} = $1;
        }
        if ($result =~ /<longt>(.*)<\/longt>/) {
            $data{longt} = $1;
        }
    }
    else {
        print "Error -- server message: " . $res->code . $res->message . "\n\n";
    }
    if ($data{latt} && $data{longt}) {
        print "\"" . $address . "\"" . "," . $data{latt} . "," . $data{longt} . "\n";
    }
    else {
        print "\"Error: " . $address . " was not geocoded\"" . "," . "," . "\n";
    }
}