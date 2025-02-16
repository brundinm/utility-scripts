#! /usr/bin/perl

# MRB: See https://unix.stackexchange.com/questions/269803/searching-usr-dict-words-to-find-words-with-certain-properties
# Will print out palindromes and reversible palindromes (semordnilap)
# To run, type "perl find-P-and-R.pl words-unix"

use strict;

my %dict = ();

print "Palindromes\n";
print "-----------\n";

while(<>) {
   chomp;
   next if (length($_) < 3);

   $dict{$_} = 1;
   print "$_\n" if ($_ eq reverse($_));
}


print "\n\nReversibles\n";
print "-----------\n";
foreach my $key (keys %dict) {

    my $len = length($key);
    my $firsthalf = '';
    my $secondhalf = '';

    if (($len / 2) == int($len/2)) {
        # even length words
        $firsthalf = substr($key,0,int($len/2));
        $secondhalf = substr($key,int($len/2));
    } else {
        # odd length words
        $firsthalf = substr($key,0,int($len/2)+1);
        $secondhalf = substr($key,int($len/2)+1);
    };

    my $rev = $secondhalf . $firsthalf;

    next unless (exists $dict{$rev});

    # don't print if reversed word is a palindrome
    next if ($rev eq $key);

    print  "$key => $rev\n";
}
