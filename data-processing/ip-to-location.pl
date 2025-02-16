#!/usr/bin/perl 
 
use lib "/u/b/r/brundin/GeoIP/Geo-IP-1.50/lib/";  
use Geo::IP; 
 
my $gi =   Geo::IP->open( "/u/b/r/brundin/GeoIP/GeoLiteCity.dat", GEOIP_STANDARD ); 
 
   my $r = $gi->record_by_name($ARGV[0]); 
     
   if ($r) { 
     print ($r->country_code . "," . $r->country_name . "," . 
            $r->region . "," . $r->region_name . "," . $r->city .  "," .
            $r->postal_code . "," . $r->latitude . "," . $r->longitude .
            "\n");
   }
   else { 
     print "\n"; 
   }
