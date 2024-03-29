#!/usr/bin/env perl

=pod

=head2

          FILE: fastagap.pl

         USAGE: ./fastagap.pl [OPTIONS] fasta

   DESCRIPTION: Report or replace/remove missing-data characters in fasta.

                Can identify and manipulate leading, trailing, and
                inner gap regions.

                Reads fasta-formatted files and writes to stdout as
                fasta or tab-separated output.

                Default behaviour (no options used) is to remove all
                occurrences of missing data represented by the symbol
                '-' from the sequences (corresponds to using the
                options -A and -G).

                If an "all-gap" sequence is encountered, it will be
                excluded from output.

                In addition, the script can also filter sequences
                on min and/or max lengths.

                See OPTIONS and EXAMPLES for more details.

       OPTIONS:
                -c, --count
                    Count and report. Do not print sequences.

                -m, --missing=<string>
                    Character <string>, or Perl regex (experimental)
                    to use as missing symbol. Default is '-'.

                -G
                    Set missing symbol to hyphen ('-'). (Default)

                -N
                    Set missing symbol to 'N' (case sensitive).

                -Q
                    Set missing symbol to '?'.

                -X
                    Set missing symbol to 'X'.

                -H, --no-header
                    Suppress printing of header in table output (use
                    together with '-c').

                -A, --remove-all
                    Remove all missing symbols from sequences. (Default)

                -L, --remove-leading
                    Remove all leading missing symbols from sequences.

                -T, --remove-trailing
                    Remove all trailing missing symbols from sequences.

                -I, --remove-inner
                    Remove all inner missing symbols from sequences.

                -E, --remove-empty
                    Explicitly remove empty sequences, i.e., fasta entries
                    with header only.

                -PA, --remove-allp=<number>
                    Remove sequence if total amount of missing data exceeds
                    <number> (in percentage). That is, allow 1 - <number>
                    percent missing data.

                -PL, --remove-leadingp=<number>
                    Remove sequence if total amount of leading missing data
                    exceeds <number> percent.

                -PT, --remove-trailingp=<number>
                    Remove sequence if total amount of missing trailing data
                    exceeds <number> percent.

                -PI, --remove-innerp=<number>
                    Remove sequence if total amount of missing inner data 
                    exceeds <number> percent.

                -PLT, --remove-leadingtrailingp=<number>
                    Remove sequence if the sum of leading- and trailing missing
                    data exceeds <number> percent.

                -a, --replace-all=<char>
                    Replace all missing symbols with <char> in sequences.

                -l, --replace-leading=<char>
                    Replace all leading missing symbols with <char> in
                    sequences.

                -t, --replace-trailing=<char>
                    Replace all trailing missing symbols with <char> in
                    sequences.

                -i, --replace-inner=<char>
                    Replace all inner missing symbols with <char> in sequences.

                -V, --Verbose
                    Print warnings when replacements are attempted on empty
                    sequences.

                -v, --version
                    Print version number.

                -w, --wrap=<nr>
                    Wrap fasta sequence to max length <nr>. Default is 60.

                -d, --decimals=<nr>
                    Use <nr> decimals for ratios in output. Default is 4.

                -MIN=<nr>
                    Print sequence if (unfiltered) length is minimum <nr> 
                    positions. This option can not be combined with the
                    removal options.

                -MAX=<nr>
                    Print sequence if (unfiltered) length is maximun <nr>
                    positions.  This option can not be combined with the
                    removal options.

                --tabulate
                    Print tab-separated output (header tab sequence).

                -uc
                    Convert sequence to uppercase. Note that the conversion
                    is done before applying any (case sensitive)
                    removal/replacements.

                -Z
                    Shortcut for '-A -N -Q -G -X --noverbose'.

                -h
                    Show brief help info.

                --help
                    Show more help info.


     EXAMPLES:  Remove all missing data ('-')

                    $ ./fastagap.pl data/missing.fasta

                Count missing data

                    $ ./fastagap.pl -c data/missing.fasta

                Count only 'N' as missing data

                    $ ./fastagap.pl -c -N data/missing.fasta

                Count '-' and '?' as missing data

                    $ ./fastagap.pl -c -G -Q data/missing.fasta

                Remove all '?'

                    $ ./fastagap.pl -Q data/missing.fasta

                Remove all leading and trailing missing data

                    $ ./fastagap.pl -L -T data/missing.fasta

                Replace leading and trailing missing data with 'N'

                    $ ./fastagap.pl -l=N -t=N data/missing.fasta

                Replace leading, trailing, and inner missing data

                    $ ./fastagap.pl -l=l -t=t -i=i data/missing.fasta

                Remove leading and trailing, and replace inner
                missing data

                    $ ./fastagap.pl -L -T -i=N  data/missing.fasta

                Remove sequence if total amount of missing data
                exceeds 30 percent

                    $ ./fastagap.pl -PA=30 data/missing.fasta

                Remove sequence if amount of leading- and trailing
                missing data exceeds 30 percent

                    $ ./fastagap.pl -PLT=30 data/missing.fasta

                Convert input sequence to uppercase before removal

                    $ ./fastagap.pl -uc -N data/missing.fasta

                Remove sequence if (unfiltered) length is less than
                5 positions

                    $ ./fastagap.pl -MIN=5 data/length.fasta

                Remove sequence if (unfiltered) length is less than
                5 positions, and not longer than 10 positions

                    $ ./fastagap.pl -MIN=5 -MAX=10 data/length.fasta

                Print (filtered) output as tab-separated

                    $ ./fastagap.pl -tabulate data/missing.fasta

  REQUIREMENTS: Perl, and perldoc (for --help)

         NOTES: The software will identify leading gaps as a contiguous region
                of missing data starting at the very first sequence position.
                Trailing gaps are the contiguous gap positions until the very
                end of the sequence. "Inner" gaps are then any gaps in between.
                Some examples:

                    '-AAAAA-'   One leading, one trailing
                    'A-----A'   No leading/trailing, five inner
                    'A------'   No leading, six trailing (no inner)
                    'A-A-A-A'   No leading/trailing, three inner
                    '-A-A-A-'   One leading, one trailing, two inner

                When encountering a sequence with all missing data the program
                will currently not attempt to replace or remove leading and
                trailing gaps. Furthermore, if all data are removed for a fasta
                entry, the entry is skipped (deleted) in the output (with a
                warning written to stderr if '--verbose' is used).

                The capacity for supplying a regex to represent the missing 
                characters is experimental. Please check the output carefully.

                Empty sequences, i.e., fasta entries with only a header, can
                be explicitly removed using the '-E' ('--remove-empty') option.
                They are also removed implicitly, along with "all-gaps" 
                sequences, when using, e.g., '-A' ('--remove-all)'.

                To get tab-separated output instead of fasta, use '--tabulate'.

                To get an easy view of the table output in a terminal window,
                one could be helped by the program 'column':

                    $ ./fastagap.pl -c data/missing.fasta | column -t

        AUTHOR: Johan Nylander

       COMPANY: NRM/NBIS

       VERSION: 1.0.1

       CREATED: Thu 14 May 2020 16:27:24

      REVISION: tor 12 okt 2023 13:10:02

       LICENSE: Copyright (c) 2019-2023 Johan Nylander

                Permission is hereby granted, free of charge, to any person
                obtaining a copy of this software and associated documentation
                files (the "Software"), to deal in the Software without
                restriction, including without limitation the rights to use,
                copy, modify, merge, publish, distribute, sublicense, and/or
                sell copies of the Software, and to permit persons to whom the
                Software is furnished to do so, subject to the following
                conditions:

                The above copyright notice and this permission notice shall be
                included in all copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
                EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
                OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
                NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
                HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
                WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
                FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
                OTHER DEALINGS IN THE SOFTWARE.

=cut

use strict;
use warnings;
use List::MoreUtils qw(all any);
use Getopt::Long;
Getopt::Long::Configure("no_ignore_case", "no_auto_abbrev");

my $version                = '1.0.1';
my $wrap                   = 60;  # fasta seq line length
my $missingchardef         = '-'; # default missing data symbol
my $decimals               = 4;   # default nr of decimals in print
my $min                    = 0;
my $max                    = q{};
my $missingchar            = q{};
my $missing                = 0;
my $G                      = 0;
my $N                      = 0;
my $Q                      = 0;
my $X                      = 0;
my $Z                      = 0;
my $count                  = 0;
my $removep                = 0;
my $removeall              = 0; # default if no other options
my $removeinner            = 0;
my $removeleading          = 0;
my $removetrailing         = 0;
my $removeallp             = 0;
my $removeinnerp           = 0;
my $removeleadingp         = 0;
my $removetrailingp        = 0;
my $removeleadingtrailingp = 0;
my $removeempty            = 0;
my $replaceall             = 0;
my $replaceinner           = 0;
my $replaceleading         = 0;
my $replacetrailing        = 0;
my $noheader               = 0;
my $verbose                = 0;
my $tabulate               = 0;
my $term                   = $/;
my $uc                     = 0;

GetOptions(
    'c|count'                       => \$count,
    'm|missing:s'                   => \$missing,
    'G'                             => \$G,
    'N'                             => \$N,
    'Q'                             => \$Q,
    'X'                             => \$X,
    'E|remove-empty'                => \$removeempty,
    'A|remove-all'                  => \$removeall,
    'I|remove-inner'                => \$removeinner,
    'L|remove-leading'              => \$removeleading,
    'T|remove-trailing'             => \$removetrailing,
    'PA|remove-allp=f'              => \$removeallp,
    'PI|remove-innerp=f'            => \$removeinnerp,
    'PL|remove-leadingp=f'          => \$removeleadingp,
    'PT|remove-trailingp=f'         => \$removetrailingp,
    'PLT|remove-leadingtrailingp=f' => \$removeleadingtrailingp,
    'MIN=i'                         => \$min,
    'MAX=i'                         => \$max,
    'a|replace-all:s'               => \$replaceall,
    'i|replace-inner:s'             => \$replaceinner,
    'l|replace-leading:s'           => \$replaceleading,
    't|replace-trailing:s'          => \$replacetrailing,
    'H|no-header'                   => \$noheader,
    'w|wrap:i'                      => \$wrap,
    'd|decimals:i'                  => \$decimals,
    'tabulate'                      => \$tabulate,
    'uc'                            => \$uc,
    'V|Verbose!'                    => \$verbose,
    'Z'                             => \$Z,
    'v|version' => sub { print "$version\n"; exit(0); },
    'h'         => sub { print "Usage: $0 [OPTIONS][--help] file\n"; exit(0); },
    'help'      => sub { exec("perldoc", $0); exit(0); },
) or
die ("$0 Error in command line arguments\nUsage: $0 [OPTIONS][--help] file\n");

if (@ARGV == 0 && -t STDIN && -t STDERR) {
    print "Usage: $0 [OPTIONS][--help] fastafile\n";
    exit(1);
}

if ($missing) {
   $missingchar = '[' . $missing . ']'; # experimental
}
elsif ($Z) {
    $missingchar = 'N|\-|\?|X';
    $removeall = 1;
    $verbose = 0;
}
else {
    my @mc = ();

    if ($G) {
        push @mc, '\-';
    }
    if ($N) {
        push @mc, 'N';
    }
    if ($Q) {
        push @mc, '\?';
    }
    if ($X) {
        push @mc, 'X';
    }

    if (@mc) {
        $missingchar = '[' . join('|', @mc) . ']'; # experimental
    }
    else {
        $missingchar = '[' . $missingchardef . ']'; # experimental
    }
}

my @do = (
    $count, $removeempty,
    $removeall, $removeinner, $removeleading, $removetrailing,
    $replaceall, $replaceinner, $replaceleading, $replacetrailing,
    $removeallp, $removeinnerp, $removeleadingp, $removetrailingp,
    $removeleadingtrailingp
);

my @dop = ($removeallp, $removeinnerp, $removeleadingp,
           $removetrailingp, $removeleadingtrailingp);

if (all { $_ eq '0' } @do) {
    $removeall = 1;
}

while (my $file = shift(@ARGV)) {

    my @fastaheaders = ();
    my %missing_HoH  = ();
    my %leading_HoH  = ();
    my %trailing_HoH = ();
    my %inner_HoH    = ();
    my %length_HoH   = ();

    open (my $FASTA, "<", $file) or die("$0 Error: Open failed: $!");

    $/ = ">";

    while (<$FASTA>) { # whole fasta entry as a chunk

        chomp;
        next if ($_ eq '');

        my $seqlength = 0;
        my $seqlength_unfiltered = 0;
        my $do_length_print = 0;
        my $nleading = 0;
        my $ntrailing = 0;
        my $ninner = 0;
        my $nmissing = 0;
        my $ngapsallowed = 0;
        my $removep = q{};
        my $header = q{};
        my $sequence = q{};
        my $inseq = q{};
        my @sequencelines = ();

        ($header, @sequencelines) = split /\n/;

        foreach my $line (@sequencelines) {
            if ($uc) {
                $sequence .= uc($line);
            }
            else {
                $sequence .= $line;
            }
        }

        if ($min || $max) { # if MIN and/or MAX args, don't filter
            $seqlength_unfiltered = length($sequence);
            if ($min > 0) { # We cannot use '>' below if min is 0
                if ($seqlength_unfiltered >= $min) {
                    if ($max) {
                        if ($seqlength_unfiltered <= $max) {
                            $do_length_print = 1;
                        }
                    }
                    else {
                        $do_length_print = 1;
                    }
                }
            }
            else {
                if ($seqlength_unfiltered > $min) {
                    if ($max) {
                        if ($seqlength_unfiltered <= $max) {
                            $do_length_print = 1;
                        }
                    }
                    else {
                        $do_length_print = 1;
                    }
                }
            }
            if ($do_length_print) {
                if ($uc) {
                    $sequence = uc($sequence);
                }
                if ($tabulate) {
                    print STDOUT $header, "\t", $sequence, "\n";
                }
                else {
                    $sequence =~ s/\S{$wrap}/$&\n/g;
                    print STDOUT ">", $header, "\n";
                    print STDOUT $sequence, "\n";
                }
            }
        }
        else {
            push @fastaheaders, $header;

            $nmissing = () = $sequence =~ /$missingchar/g;
            $missing_HoH{$file}{$header} = $nmissing;

            $seqlength = length($sequence);
            $length_HoH{$file}{$header} = $seqlength;

            if ($sequence =~ /^(${missingchar}+)/) {
                $nleading = length($1);
            }
            $leading_HoH{$file}{$header} = $nleading;

            if ($sequence =~ /(${missingchar}+$)/) {
                $ntrailing = length($1);
            }
            $trailing_HoH{$file}{$header} = $ntrailing;

            my $len = $seqlength - $nleading - $ntrailing;
            $inseq = substr($sequence, $nleading, $len);

            if (($nleading == $seqlength) or ($ntrailing == $seqlength)) {
                $ninner = 0;
            }
            else {
                $ninner = $nmissing - ($nleading + $ntrailing);
            }
            $inner_HoH{$file}{$header} = $ninner;

            if (any { $_ > '0' } @dop) {
                if ($removeallp) {
                    $removep = $removeallp;
                    $ngapsallowed = ($removep/100.0) * $seqlength;
                }
                elsif ($removeleadingp) {
                    $removep = $removeleadingp;
                    $nmissing = $nleading;
                    $ngapsallowed = ($removep/100.0) * $seqlength;
                }
                elsif ($removetrailingp) {
                    $removep = $removetrailingp;
                    $nmissing = $ntrailing;
                    $ngapsallowed = ($removep/100.0) * $seqlength;
                }
                elsif ($removeinnerp) {
                    $removep = $removeinnerp;
                    $nmissing = $ninner;
                    $ngapsallowed = ($removep/100.0) * $seqlength;
                }
                elsif ($removeleadingtrailingp) {
                    $removep = $removeleadingtrailingp;
                    $nmissing = $nleading + $ntrailing;
                    $ngapsallowed = ($removep/100.0) * $seqlength;
                }
            }
            else {
                $ngapsallowed = $seqlength - 1;
            }

            if (! $count) {
                if ($replaceall) {
                    $sequence =~ s/$missingchar/$replaceall/g;
                }

                if ($replaceleading) {
                    my $lN = $replaceleading x $nleading;
                    if ($nleading == $seqlength) {
                        if ($verbose) {
                            print STDERR "$0 Warning: found sequence with no data." .
                            " Will not replace leading from \'$header\'" .
                            " (file \'$file\')\n";
                        }
                    }
                    else {
                        substr($sequence, 0, $nleading, $lN);
                    }
                }

                if ($replacetrailing) {
                    if ($ntrailing == $seqlength) {
                        if ($verbose) {
                            print STDERR "$0 Warning: found sequence with no data." .
                            " Will not replace trailing from \'$header\'" .
                            " (file \'$file\')\n";
                        }
                    }
                    else {
                        my $tN = $replacetrailing  x $ntrailing;
                        substr($sequence, -$ntrailing, $ntrailing, $tN);
                    }
                }

                if ($replaceinner) {
                    $inseq =~ s/$missingchar/$replaceinner/g;
                    my $inseqlen = length($inseq);
                    substr($sequence, $nleading, $inseqlen) = $inseq;
                }

                if ($removeleading) {
                    if ($nleading == $seqlength) {
                        if ($verbose) {
                            print STDERR "$0 Warning: found sequence with no data." .
                            " Will not remove leading from \'$header\'" .
                            " (file \'$file\')\n";
                        }
                    }
                    else {
                        substr($sequence, 0, $nleading, q{});
                    }
                }

                if ($removetrailing) {
                    if ($ntrailing == $seqlength) {
                        if ($verbose) {
                            print STDERR "$0 Warning: found sequence with no data." .
                            " Will not remove trailing from \'$header\'" .
                            " (file \'$file\')\n";
                        }
                    }
                    else {
                        substr($sequence, -$ntrailing, $ntrailing, q{});
                    }
                }

                if ($removeinner) {
                    $inseq =~ s/$missingchar//g;
                    my $inseqlen = length($inseq);
                    substr($sequence, $nleading, $inseqlen) = $inseq;
                }

                if ($removeall) {
                    $sequence =~ s/$missingchar//g;
                }

                if (length($sequence) < 1) {
                    if ($verbose) {
                        print STDERR "$0 Warning: found sequence with no data." .
                        " Removing \'$header\' (file \'$file\') from output.\n";
                    }
                }
                else {
                    if ($nmissing > $ngapsallowed) {
                        if ($verbose) {
                            print STDERR "$0 Warning: missing data > $removep\%." .
                            " Removing \'$header\' (file \'$file\') from output.\n";
                        }
                    }
                    else {
                        if ($tabulate) {
                            print STDOUT $header, "\t", $sequence, "\n";
                        }
                        else {
                            $sequence =~ s/\S{$wrap}/$&\n/g;
                            print STDOUT ">", $header, "\n";
                            print STDOUT $sequence, "\n";
                        }
                    }
                }
            }
        }
    }
    close($FASTA);

    $/ = $term;

    if ($count) {

        my ($seqlen, $Nmiss, $Nlead, $Ntrail,$Ninner,
            $sumlt, $mratio, $lratio, $tratio,
            $iratio, $sumltratio);
        my @print_array = ();

        if (!$noheader) {
            print STDOUT "label\tlength\t${missingchar}\tratio\t" .
                    "lead\tlratio\ttrail\ttratio\tl+t\tltratio\t" .
                    "inner\tiratio\tfile\n";
        }

        foreach my $label (@fastaheaders) {
            $seqlen = $length_HoH{$file}{$label};
            if ($seqlen == 0) {
                $Nmiss = $mratio = $Nlead = 0;
                $lratio = $Ntrail = $tratio = 0;
                $sumlt = $sumltratio = $Ninner = $iratio = 0;
            }
            else {
                $Nmiss = $missing_HoH{$file}{$label};
                $Nlead = $leading_HoH{$file}{$label};
                $Ntrail = $trailing_HoH{$file}{$label};
                $Ninner = $inner_HoH{$file}{$label};
                $sumlt = 0;

                if (($Nlead == $seqlen) or ($Ntrail == $seqlen)) {
                    $sumlt = $seqlen;
                }
                else {
                    $sumlt = $Nlead + $Ntrail;
                }

                $mratio = $Nmiss / $seqlen;
                $lratio = $Nlead / $seqlen;
                $tratio = $Ntrail / $seqlen;
                $iratio = $Ninner / $seqlen;
                $sumltratio = $sumlt / $seqlen;
            }

            @print_array = ($label, $seqlen, $Nmiss, $mratio, $Nlead,
                            $lratio, $Ntrail, $tratio, $sumlt,
                            $sumltratio, $Ninner, $iratio, $file);

            printf STDOUT "%s\t%d\t%d\t%.${decimals}f\t%d\t%.${decimals}f\t" .
                          "%d\t%.${decimals}f\t%d\t%.${decimals}f\t%d\t" .
                          "%.${decimals}f\t%s\n", (@print_array);
        }
    }
}
exit(0);

