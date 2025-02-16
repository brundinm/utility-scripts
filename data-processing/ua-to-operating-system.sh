#!/bin/bash
operating_system=`echo $1 | perl -nE 'use HTTP::BrowserDetect; $ua =  HTTP::BrowserDetect->new($_); say $ua->os_string || "";'`
printf "$operating_system\n"
