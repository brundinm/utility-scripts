#!/bin/bash
browser=`echo $1 | perl -nE 'use HTTP::BrowserDetect; $ua =  HTTP::BrowserDetect->new($_); say $ua->browser_string || "";'`
printf "$browser\n"
