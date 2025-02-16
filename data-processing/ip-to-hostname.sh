#!/bin/bash
hostname=`perl -MSocket -E "say scalar gethostbyaddr(inet_aton(\"$1\"), AF_INET)"`
printf "$hostname\n"
