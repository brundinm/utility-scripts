#!/bin/bash

# MRB -- Sat 07-Oct-2017

# Purpose: Shell script for command functions

# character commands
function charconvertligatures() {
    sed "s/œ/oe/g;s/Œ/OE/g;" $1
}
function charnoascii() {
    gawk '/[^\x00-\x7F]/{print NR":"$0}' $1
}
function charnoutf8() {
    grep -anxv '.*' $1
}
function charremovediacritics() {
    cat $1 | tr "àâäèéêëîïôùûüÿçÀ ÄÈÉÊËÎÏÔÙÛÜŸÇ" "aaaeeeeiiouuuycAAAEEEEIIOUUUYC"
}
function charunixtowin() {
    sed 's/$/\r/' $1
}
function charwintounix() {
    sed 's/\r$//' $1
}

# document commands
function docdescstats1() {
    sort -n $1 | awk '{a[i++]=$0;s+=$0}END{print "count: " NR"\n" "minimum: " a[0] "\n" "maximum: " a[i-1] "\n" "median: " (a[int(i/2)]+a[int((i-1)/2)])/2 "\n" "mean: " s/i}'
}
function docdescstats2() {
    perl -e 'use List::Util qw(max min sum); @a=();while(<>){$sqsum+=$_*$_; push(@a,$_)}; $n=@a;$s=sum(@a);$a=$s/@a;$m=max(@a);$mm=min(@a);$std=sqrt($sqsum/$n-($s/$n)*($s/$n));$mid=int @a/2;@srtd=sort @a;if(@a%2){$med=$srtd[$mid];}else{$med=($srtd[$mid+1]+$srtd[$mid])/2;};print "cnt: $n\nsum: $s\navg: $a\nstd: $std\nmed: $med\nmax: $m\min: $mm";' $1
}
function docfreqdist() {
    sort $1 | uniq -c | sort -k1,1nr -k2,2n | awk ' { t = $1; $1 = $2; $2 = t; print; } '
}
function doclinefreq() {
    sort $1 | uniq -c | sort -nr
}
function docpopstddev() {
    awk '{sum+=$1; sumsq+=$1*$1;} END {print "pop stdev = " sqrt(sumsq/NR - (sum/NR)**2);}' $1
}
function docsamstddev() {
    cat $1 | awk '{delta = $1 - avg; avg += delta / NR; mean2 += delta * ($1 - avg); } END { print "sample stdev = " sqrt(mean2 / (NR-1)); }'
}
function docsum() {
    awk '{s+=$1} END {print s}' $1
}
function docwordfreq1() {
    cat $1 | tr -d "[:punct:]" | tr " " "\n" | tr "A-Z" "a-z" | sort | uniq -c | sort -k1,1nr -k2,2
}
function docwordfreq2() {
    cat $1 | tr -d '[:punct:]' | tr '[A-Z]' '[a-z]' | awk '{for (i=1;i<=NF;i++) print $i;}' | sort | uniq -c |sort -rn -k1
}

