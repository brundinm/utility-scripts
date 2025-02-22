#!/usr/bin/env perl
# by Harry Mangalam, hjmangalam@gmail.com.com.

# after significant changes, update the tarballs that need it and cp to moo for distribution; update the scut github
# export filename="/home/hjm/bin/stats"; scp ${filename} moo:~/public_html; scp ${filename} moo:~/bin;  scp ${filename}   dabrick:~/bin; ssh moo 'scp bin/stats hmangala@hpcs:~/bin'

# cd ~/gits/scut; cp ~/bin/stats .; git add stats; git commit -m 'commit message'; git push

use strict;
use Getopt::Long;

use vars qw( $wide $dist $Xsize $Ysize $ln $N $sum $Min $Max $XYDist @Data $pager
    $XRange $XBinSize $XMul @SData $NWH $Median $even $Mean $SumDiffs2 $SumDiffs3 
    $SumDiffs4 $ValCnt $Val $MaxSoFarValCnt $ModeInd @Dist $jmin $jmax $J $YMax 
    $YBinSize $YMul @XYDist $ModeNum $Mode $S2 $S $Kurtosis $SEM $Skew $StdSkew 
    $gfmt $VERSION $DATE $HELPFILE $HELP $ConfIntLow $ConfIntHi $QUIET $stdout 
    %xfhash $xf $id $od
);
$VERSION = "2.0.5";
$DATE = "Nov 28, 2017";
if (!defined $ENV{'PAGER'}) {$pager = "less";};
$gfmt = 0;
$NWH = 0;
$stdout = 0;
%xfhash = (
  'log10'  => 1,  'ln'     => 1,  'sqrt'   => 1,  'x^2'    => 1,  'x^3'    => 1,
  '1/x'    => 1,  'sin'    => 1,  'cos'    => 1,  'tan'    => 1,  'asin'   => 1,
  'acos'   => 1,  'atan'   => 1,  'round'  => 1,  'trunc'  => 1,  'frac'   => 1,
  'abs'    => 1,  'exp'    => 1,  'pass'   => 1,  ''       => 1
  );  

&GetOptions(
   "wide!"   => \$wide,  # no args - just set to 1
   "dist=i"  => \$dist,  # 1 for 1-liner, 2 for xy plot with the following vars, 3 for both
   "x=i"     => \$Xsize, # the # of characters in the X axis
   "y=i"     => \$Ysize, # the # of lines in the Y axis
   "help!"   => \$HELP,  # ask for help
   "h!"      => \$HELP,
   "quiet!"  => \$QUIET, # shhhhh!
   "nwh!"    => \$NWH,   # No Wide Headers (if repeating wide mode, don't want headers)
   "stdout!" => \$stdout,   # just print, don't do stats on the numbers
   "xf=s"    => \$xf,    # do a transform of the #s before doing anything.
   "gfmt!"   => \$gfmt,  # set to Perl's 'general' numeric notation
   "id=s"   =>  \$id,    # input delimiter
   "od=s"   =>  \$od,    # output delimiter
);

# 11.28.2017 added xf=pass for simple text/data filtering.
# 11.10.2017 added transforms (--xf) & --stdout so stats can be used as an inline transform
# 06.15.2017  added 95% confidence intervals
# 03.12.2014 added '--quiet' to silence non-fatal warnings.
# 01.11.12 added 'general numeric format, replacing strict sci notation
# 05.01.08 added comma removal after embarrassing conversation with credit card company
#  7.14.06 add --sci to format for scientific notation output. ie:
#  --sci
#  2.05.01 addded Distribution calc/graph
#  2.01.01 format change to ease integration (Mode, NMode# split onto separate lines)
#         Made Labels single words and unambiguous for easier grepping

# 11.10.00 added wide printing (--wide)
#  9.27.00 adding check for included non-numbers
#  4.21.00 adding check for FLAT mode, modecount =1
# 11.24.99 adding Mode, Mode count, Median to output.

$N = 0;
$sum = 0;
$Min = $Max = 0;

# handle input and offer help if none.
if (-t STDIN) {
    if ($HELP) {usage()}
    else {
        print "\n[$0] will emit descriptive statistics based on 
all number-like input fed it on STDIN.  Use '-h' for more help.\n"; 
    }
    exit 0;
}

# define undefined vars

if (!$xfhash{$xf}){die "ERROR: I don't support that transform; try again or see the help (-h)\n"; }
#print "xf = $xf\n";
if (!defined $Xsize) { $Xsize = 60; }
if (!defined $Ysize) { $Ysize = 25; }
if (!defined $id) {$id = "\\s+";}
if (!defined $od) {$od = "\t";}

#Zero the DIST array
for (my $x=0; $x<$Xsize; $x++) {
  for (my $y=0; $y<$Ysize; $y++) {
    $XYDist[$x][$y] = ' ';
  }
}

# main loop to ingest data
while (<>) {
    $_ = trim($_);
    my $x = my @arr = split /$id/;
    for (my $i = 0; $i < $x; $i++) {
        # make sure all the things we're including are number-like
        # remove commas to prevent rejection downstream
        $arr[$i] =~ s/,//g;
        if (($arr[$i] =~ /\d+|\d*\.\d*|\d+\.\d*[eE]-?\d+/) &&
            ($arr[$i] !~ /[a-df-zA-DF-Z]+/) ) {
#            print "[$i] = $arr[$i]\n";
            if (defined $xf) { # want to exec a transform; already checked that its supported.
                # some of these are direct maps to perl-supplied functions; others have to be munged.
                
                my $v = $arr[$i];
                if    ($xf eq "pass")  { $arr[$i] = $v} # simply a filtering and passthru.
                elsif ($xf eq "log10") { if ($v > 0) { $arr[$i] = log($v) / log(10);} else { $arr[$i] = "NA";} }
                elsif ($xf eq "ln")    { if ($v > 0) { $arr[$i] = log($v);}           else { $arr[$i] = "NA";} }
                elsif ($xf eq "sqrt")  { if ($v >= 0) { $arr[$i] = sqrt($v);}         else { $arr[$i] = "NA";} }
                elsif ($xf eq "x^2")   { $arr[$i] *= ($v)}
                elsif ($xf eq "x^3")   { $arr[$i] = ($v)*($v)*($v)}
                elsif ($xf eq "1/x")   { $arr[$i] = 1 / $v }
                elsif ($xf eq "sin")   { $arr[$i] = sin($v) }
                elsif ($xf eq "cos")   { $arr[$i] = cos($v) }
                elsif ($xf eq "tan")   { $arr[$i] = sin($v) / cos($v) }
                elsif ($xf eq "asin")  { $arr[$i] = 1 / sin($v) }
                elsif ($xf eq "acos")  { $arr[$i] = 1 / cos($v) }
                elsif ($xf eq "atan")  { $arr[$i] = 1 / tan($v) }
                elsif ($xf eq "round") { $arr[$i] = int ($v + 0.5) }
                elsif ($xf eq "trunc") { $arr[$i] = int ($v) }
                elsif ($xf eq "frac")  { $arr[$i] = $v - int($v) }
                elsif ($xf eq "abs")   { $arr[$i] = abs($v) }
                elsif ($xf eq "exp")   { $arr[$i] = exp($v) }
            }
        if ($stdout) {
            my $y = $x-1;
            if ($gfmt) { printf "%g", $arr[$i]; if ($i<$y) {print "$od"} else {print "\n";} }
            else       { print "$arr[$i]";      if ($i<$y) {print "$od"} else {print "\n";} }
        }
#        print "\n";
            
    #         if ($ln) {
    #           if ($arr[$i] > 0) { $arr[$i] = log($arr[$i]); }
    #           elsif (! $QUIET) { print STDERR "Detected # <= 0 ($arr[$i] @ ~ line $N)- Maybe shouldn't use that transform!!\n"}
    #        }
            $sum += $arr[$i]; # sum the numbers as they come in
        if ($N == 0) {
            $Min = $Max = $arr[$i];
        }
        if ($arr[$i] < $Min) { $Min = $arr[$i]; }
        if ($arr[$i] > $Max) { $Max = $arr[$i]; }
        $Data[$N++] = $arr[$i];  # store them for calcing the SD, etc
        }
#         if ($stdout) {
#             my $y = $x-1;
#             if ($gfmt) { printf "%g", $arr[$i]; if ($i<$y) {print "$od"}}
#             else       { print "$arr[$i]"; if ($i<$y) {print "$od"}}
#         }
#         print "\n"
    }
}   

   
#     if ($stdout) {
#         my $i; my $y = $x-1;
#         if ($gfmt) {
#             for ($i=0; $i<$x; $i++){ printf "%g", $arr[$i]; if ($i<$y) {print "$od"}}
#         } else {
#             for ($i=0; $i<$x; $i++){ print "$arr[$i]"; if ($i<$y) {print "$od"}}
#         }
#         print "\n"
#     }   


if (! $stdout) {
    # All the numbers sucked in; now calc the values wanted

    # autoscale the X axis
    $XRange = $Max - $Min;
    if ($XRange != 0){
        $XBinSize = $XRange/$Xsize;
        $XMul = $Xsize/$XRange;
    } else {
        $XBinSize = -1;
        $XMul = -1;
    }

    # if want to get mode, median, would help to sort $Data
    @SData = sort {$a <=> $b}  @Data;

    if ($N % 2 < 0.001) {
        #then $N is even and we can calc median via...
    $Median = ($SData[($N-1)/2] + $SData[(($N-1)+2)/2]) / 2;
        $even = 1;
    } else {
        # then $N is odd and we can calc median via...
    $Median = ($SData[($N+1)/2]) ;
        $even = 0;
    }
    $Mean = $sum / $N;
    $SumDiffs2 = 0;
    $SumDiffs3 = 0;
    $SumDiffs4 = 0;

    $MaxSoFarValCnt = 0;
    $ModeInd = 0;
    $ValCnt = 0;
    $Val = $SData[0];

    #init Distribution array
    for (my $i=0; $i<$Xsize; $i++){
    $Dist[$i] = 0;
    }
    $jmin = $jmax = 0;

    for (my $i=0; $i < $N; $i++){
        $SumDiffs2 = $SumDiffs2 + (($Data[$i] - $Mean)**2);
        $SumDiffs3 = $SumDiffs3 + (($Data[$i] - $Mean)**3);
        $SumDiffs4 = $SumDiffs4 + (($Data[$i] - $Mean)**4);

        # this next stanza calculates the Mode pointer
    if ($Val == $SData[$i]) {
        # if its another of the same #, incr the counters
        $ValCnt++;
        $Val = $SData[$i];
    } else { # it's a new value, so check if the run of the last set of #s
                # exceeds the longest so far
        if ($ValCnt > $MaxSoFarValCnt) {
            # and if so, replace the old values with the new 'winners'
            $MaxSoFarValCnt = $ValCnt;
            $ModeInd = $i-1;
        }
        # and reset the counters for the new
        $ValCnt = 0;
    }
    $Val = $SData[$i];

    # calc the distribution
    if ($XMul > 0) {
            $J = int($Data[$i] * $XMul);
            if ($J < $jmin) { $jmin = $J; }
            if ($J > $jmax) { $jmax = $J; }
            $Dist[$J]++;  # range of Dist should be close to $Xsize
    } #else {print "\nErr: All #s same, no range, no distribution\n";}
    }

    #Scale the Y axis; 1st find out the range for Y
    $YMax = 0;
    for (my $i=0; $i<$jmax; $i++) {
    if (abs($Dist[$i]) > $YMax) { $YMax = abs($Dist[$i]);}
    }
    if ($YMax == 0) { $YMax = 1;}
    $YBinSize = $YMax/($Ysize-1);
    #print "\nYMax = $YMax\n";
    $YMul = ($Ysize-1) / $YMax;
    for (my $x=0; $x<$Xsize; $x++) {
    my $y = int($Dist[$x] * $YMul);
    $XYDist[$x][$y] = '*';
    }


    if ($XMul > 0) {
        if ($MaxSoFarValCnt > 1) {
            $ModeNum = $MaxSoFarValCnt + 1;
            $Mode = $SData[$ModeInd];
        } else {
            $ModeNum = "No # was represented more than once";
            $Mode = "FLAT";
        }
        $S2 = $SumDiffs2 / ($N - 1);
        $S = sqrt($S2);
        $Kurtosis = ($SumDiffs4 / (($N-1)*($S**4))) - 3;
        $SEM = $S / sqrt($N);
        if ($S > 0 && $N > 3) {
        $Skew = ($N * $SumDiffs3) / (($N-1) * ($N-2) * ($S ** 3));
        $StdSkew = $Skew / sqrt(6/$N);
        $ConfIntHi  = $Mean + (1.96 * ($S/sqrt($N)));
        $ConfIntLow = $Mean - (1.96 * ($S/sqrt($N)));
        }
    }

    if (!$wide && $gfmt == 0) {
    print  "Sum       $sum",
            "\nNumber    $N",
            "\nMean      $Mean",
            "\nMedian    $Median",
            "\nMode      $Mode  ",
            "\nNModes    $ModeNum",
            "\nMin       $Min",
            "\nMax       $Max",
            "\nRange     $XRange",
            "\nVariance  $S2",
            "\nStd_Dev   $S",
            "\nSEM       $SEM",
            "\n95% Conf  $ConfIntLow to $ConfIntHi",
            "\n          (for a normal distribution - see skew)\n";
    } elsif (!$wide && $gfmt > 0) {  # shorten this post verify
    printf   "Sum       %g", $sum;
    printf "\nNumber    %g",$N;
    printf "\nMean      %g",$Mean;
    printf "\nMedian    %g",$Median;
    printf "\nMode      %g",$Mode;
    printf "\nNModes    %g",$ModeNum;
    printf "\nMin       %g",$Min;
    printf "\nMax       %g",$Max;
    printf "\nRange     %g",$XRange;
    printf "\nVariance  %g",$S2;
    printf "\nStd_Dev   %g",$S;
    printf "\nSEM       %g",$SEM;
    printf "\n95% Conf  %g to %g", $ConfIntLow, $ConfIntHi;
    print  "\n          (for a normal distribution - see skew)\n";
    }


    if ($S > 0 && $N > 3 && !$wide) {
        if (!$gfmt) {
            print  "Skew      $Skew",
                "\n          (skew is 0 for a symmetric dist)",
                "\nStd_Skew  $StdSkew",
                "\nKurtosis  $Kurtosis",
                "\n          (K=3 for a normal dist)\n";
        } else {
                    printf   "Skew      %g", $Skew;
                    print  "\n          (skew = 0 for a symmetric dist)";
                    printf "\nStd_Skew  %g", $StdSkew;
                    printf "\nKurtosis  %g", $Kurtosis;
                    print  "\n          (K=3 for a normal dist)\n";
        }
    } elsif (! $QUIET) {
        print STDERR "#Std Dev = 0 or N <=3 or printing wide; Skipping Skewness, Std Skewness cal'n.\n";
    }

    if ($wide) {
    if (!$NWH){
        print  "#Sum\tN\tMean\tMedian\tMode\tNModes\tMin\tMax\tRange\tVariance\tStd Dev\tSEM\t95%L\t95%H\tSkew\tStd Skew\tKurtosis\n";
    }
    if ($gfmt) {
        printf "%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g", $sum,$N,$Mean,$Median,$Mode,$ModeNum,$Min,$Max,$XRange,$S2,$S,$SEM,$ConfIntLow,$ConfIntHi;
    } else {
        print "$sum\t$N\t$Mean\t$Median\t$Mode\t$ModeNum\t$Min\t$Max\t$XRange\t$S2\t$S\t$SEM\t$ConfIntLow\t$ConfIntHi";
    }
    if ($S > 0 && $N > 3) {
        if ($gfmt) {
            printf "\t%g\t%g\t%g\n", $Skew,$StdSkew,$Kurtosis;
        } else { print "\t$Skew\t$StdSkew\t$Kurtosis\n";}
    } elsif (! $QUIET) {
        print  STDERR "NA\tNA\nStd Dev = 0 or N <=3; Skipping Skewness, Std Skewness, Kurtosis cal'n.\n";
    }
    }

    # print out the distribution
    # this way prints it out in 1 line
    if ($dist == 1 || $dist == 3) {
    for (my $r=0; $r<($Xsize); $r++) {
        if ($Dist[$r] < 10) { print $Dist[$r]; }
        else { print "($Dist[$r])"; }
    }
    }
    # this way prints a little xy graph, if wanted
    my $spacer = "";
    for (my $x=0; $x<($Xsize - 14); $x++) { $spacer = $spacer . " ";}

    if ($XBinSize > 0) {
        if ($dist == 2 || $dist == 3) {
            print "\n\nDistribution\nX BinSize $XBinSize\nY BinSize  $YBinSize\n\nYMax:$YMax\n      |";
            for (my $y=($Ysize-1); $y>=0; $y--) {
            for (my $x=0; $x<$Xsize; $x++) {
                print "$XYDist[$x][$y]";
            }
            print "\n      |";
            }
            for (my $x=0; $x<$Xsize; $x++) { print '-';}
            print "\n  X Min $spacer        X Max\n";
            #for (my $x=0; $x<($Xsize - 15); $x++) { print ' ';}
            #print "X Max: $Max \n";
            printf "%7.2f %s %12.2f \n", $Min, $spacer, $Max;
            if (!$ln) {
                print "\nIf points are jammed at one end, use '--xf=ln' to spread them.\n";
            }
        }
    } else {
        print STDERR "\nINFO: Identical numbers in input; no range, no distribution\n";
    }
}
 
 
sub trim($)
    {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

sub usage {
my $LESSHELP = <<HELP;
 stats version: $VERSION, last mod: $DATE

 stats is a utility that reads STDIN for all #s, whether in one line
 or in many (removes commas, checks for text contaminents; only have to 
 be separated by whitespace), calculates some basic stats, then spits 
 them to STDOUT to be grep'ed in the std unixy way.
 
 Starting in V2, you can choose from a small set of transforms (see 
 below) to be applied to the data and then emitted with '--stdout' 
 (thus using stats as a transform filter) or  have the stats applied 
 to that transformed data.

 usage: stats < file.of.numbers
     or
 cmd1 | cmd2 |cmd3 | stats [options]

 where Options are:
       --wide ............ writes the stats in 1-line (useful for some
                                                     spreadsheet apps)
       --dist=# .................. plots a distribution function where
                    where # = 1 = 1-liner distribution
                              2 = the std xy plot of the data
                              3 = both 1 liner & longer version
         (hint: pipe '--stdout' into 'feedgnuplot' for better plotting)
       --x=# ..................where # = an integer indicating the # of
                                               characters in the X axis
       --y=# ..................................... ditto for the y axis
       --help .......................................   dumps this help
       --nwh ...... 'No Wide Headers' (no headers on wide output output
                        good for repeating output as for logging stuff)
       --xf="fn" ..... to transform STDIN before doing the stats, where
                         "fn" is one of log10, ln, sqrt, x^2, x^3, 1/x, 
                       sin, cos, tan, asin, acos, atan, round, abs, exp, 
                 pass(thru), trunc (integer part), frac (decimal part). 
       --stdout ....... JUST print STDIN to STDOUT (don't do any stats)
                                          (--xf also applies to STDOUT)
       --id="token" .... Input delimiter; defaults to whitespace (\\s+)
       --od="token" ........... Output delimiter; defaults to tab (\\t)
       --gfmt ............. output in Perl's 'general numeric notation'
       --quiet ...................... decrease amount of error messages

Example 1:
=======================================================================
Calculate the file size distribution in the current directory:

\$ ls -l | awk '{print \$5}'  | stats2  --gfmt --dist=2 --x=20 --y=10
Sum       5.72512e+08
Number    172
Mean      3.32856e+06
Median    13918
Mode      4096
NModes    11
Min       0
Max       2.84115e+08
Range     2.84115e+08
Variance  7.56924e+14
Std_Dev   2.75123e+07
SEM       2.09779e+06
95% Conf  -783109 to 7.44023e+06 **
          (for a normal distribution - see skew)
Skew      9.3415
          (skew = 0 for a symmetric dist)
Std_Skew  50.0155
Kurtosis  84.6439
          (K=3 for a normal dist)

** This assumes normal distribution, but since this distribution is 
   extremely skewed, the confidence limits will be inaccurate.
   (for a web page that calculates more descriptive stats, including 
   estimation of normality, see: http://www.xuru.org/st/DS.asp
   for specific plots or analyses, see: http://www.wessa.net/desc.wasp

Distribution
X BinSize 14205747.2
Y BinSize  18.7777777777778

YMax:169
      |*                   
      |                    
      |                    
      |                    
      |                    
      |                    
      |                    
      |                    
      |                    
      | *******************
      |--------------------
  X Min               X Max
   0.00        284114944.00 

If points are jammed at one end, use '--xf=ln' to spread them.

** This assumes normal distribution, but since this distribution is 
   extremely skewed, the confidence limits will be inaccurate.
   (for a web page that calculates more descriptive stats, including 
   estimation of normality, see: http://www.xuru.org/st/DS.asp
   for specific plots or analyses, see: http://www.wessa.net/desc.wasp
=======================================================================

Example 2:
=======================================================================
Calculate the file size distribution in the current directory with the 
suggested ln transform.  
NB: Note that the stats are calculated with the transformed data.

\$ ls -l | awk '{print \$5}'  | stats2 --xf='ln' --gfmt --dist=2 --x=20 --y=10
Sum       1597.38
Number    172
Mean      9.28707
Median    9.54093
Mode      8.31777
NModes    11
Min       0
Max       19.4649
Range     19.4649
Variance  12.8159
Std_Dev   3.57994
SEM       0.272968
95% Conf  8.75205 to 9.82208
          (for a normal distribution - see skew)
Skew      -0.297273
          (skew = 0 for a symmetric dist)
Std_Skew  -1.59164
Kurtosis  0.47218
          (K=3 for a normal dist)


Distribution
X BinSize 0.973244472331889
Y BinSize  2.66666666666667

YMax:24
      |           *        
      |         *          
      |        *           
      |            *       
      |     *    *         
      |                    
      |      **     *      
      |    *          *    
      |**            *     
      |  **            ****
      |--------------------
  X Min               X Max
   0.00               19.46 


 = Hint: while the above plotting function is better than nothing, 
 consider using 'feedgnuplot' to plot columns of numbers. 
 ex:  scut/cut [options] | feedgnuplot --lines --points --domain

   
 Feel free to add whatever additional calculations you want,
 but if you do and you think they might be of general use,
 let me know so I can add them to the original.
 Bug reports, suggestions back to the author (hjmangalam\@gmail.com)

HELP

$HELPFILE = ".statshelpfile" . $$; # write a hidden helpfile
open(HF, ">$HELPFILE") or die "Can't open helpfile [$HELPFILE] at __LINE__ \n";
print HF $LESSHELP;
close HF;
system("$pager $HELPFILE");
unlink $HELPFILE; # and get rid of it asap
exit 0;
}

exit 0;
