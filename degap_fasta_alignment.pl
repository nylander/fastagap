#!/usr/bin/env perl
#===============================================================================
=pod

=head2

         FILE: degap_fasta_alignment.pl

        USAGE: ./degap_fasta_alignment.pl [--all][--any][--outfile=<file>] fasta_file

  DESCRIPTION: Removes columns with all gaps from aligned FASTA files.
               Default (no option arguments) is to remove columns
               where all taxa have gaps, thus preserving the
               alignment.

      OPTIONS: 
               --all
                 Remove all gap characters from the sequences, thus
                 not preserving the alignment.

               --any
                 Remove all columns containing any gaps from the
                 sequences, while preserving the alignment.

               --gap=<char>
                 Set the gap symbol to <char>. Default is '-'.

               --outfile=<file>
                 Print to <file>. Default is to print to STDOUT.

 REQUIREMENTS: ---

        NOTES: This version reads one file only.

       AUTHOR: Johan Nylander (JN), johan.nylander@nrm.se

      COMPANY: NBIS/NRM

      VERSION: 2.0

      CREATED: 02/22/2010 07:12:32 PM CET

     REVISION: fre  8 apr 2022 18:23:59

      LICENSE: Copyright (c) 2019-2022 Johan Nylander

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

#===============================================================================

use warnings;
use strict;
use Getopt::Long;

my $usage = "\nUsage: $0 [--all][--any][-g=<char>][-o=<file>][-h] FASTA_file\n
  Default (no option arguments) is to remove columns containing gaps-only,
  while preserving the alignment.\n
  --all   Remove all gap characters (-) from the sequences,
  thus not preserving the alignment.\n
  --any   Remove all columns containing any gaps from the
  sequences, while preserving the alignment.\n
  --gap=<char>   Set the gap symbol to <char>. Default is '-'.\n
  --outfile=<file>   Print output to <file>. Default is to
  print to STDOUT.\n
  --help  Print this help text.
  \n";

## Some defaults
my $all          = 0;
my $any          = 0;
my $gap          = '-';
my $print_length = 80;
my $verbose      = 0;
my $debug        = 0;
my $outfile      = q{};
my $PRINT_FH     = *STDOUT; # Using the typeglob notation in order to use STDOUT as a variable

## Handle arguments
if (@ARGV < 1) {
    die $usage;
}
else {
    GetOptions('help'      => sub {print $usage; exit(0);},
               'all'       => \$all,
               'any'       => \$any,
               'gap:s'     => \$gap,
               'outfile:s' => \$outfile,
               'verbose'   => \$verbose,
               'debug'     => \$debug,
              );
}

## Read only one FASTA file
my $fasta = shift(@ARGV); 

## Read FASTA file
my %seq_hash    = ();
my @names       = ();
my $name        = q{};
my @gap_columns = ();

open my $FASTA, "<", $fasta or die "Couldn't open '$fasta': $!";
print STDERR "$fasta: " if $verbose;
while (<$FASTA>) {
    chomp();
    if (/^\s*>\s*(.+)$/) {
        $name = $1;
        die "Duplicate name: $name" if defined $seq_hash{$name};
        push @names, $name;
    }
    else {
        if ( /\S/ && !defined $name ) {
            warn "Ignoring: $_";
        }
        else {
            print STDERR "replacing white space in input\n" if $verbose;
            s/\s//g;
            print STDERR "splitting line in input\n" if $verbose;
            my @line = split //, $_;
            print STDERR "pushing lines in input\n" if $verbose;
            push ( @{$seq_hash{$name}}, @line );
        }
    }
}
close $FASTA;

## Check if all seqs have the same length
my $length;
my $lname;
foreach my $name (@names) {
    my $l = scalar @{$seq_hash{$name}};
    if ( defined $length ) {
        die "Sequences not all same length ($lname is $length, $name is $l)"
          unless $length == $l;
    }
    else {
        $length = scalar @{$seq_hash{$name}};
        $lname  = $name;
    }
}

## Do options
if ($all) {
    ## Remove all gaps from the sequences
    foreach my $key (keys %seq_hash) {
        foreach my $l (@{$seq_hash{$key}}) {
            $l =~ s/$gap//g;
        }
    }
}
elsif ($any) {
    ## Remove columns containing any gaps 
    for (my $i = 0; $i < $length ; $i++) {
        OVER_TAX:
        foreach my $tax (keys %seq_hash) {
            my $pos = $seq_hash{$tax}->[$i];
            if ($pos eq $gap) {
                push @gap_columns, $i;
                last OVER_TAX;
            }
        }
    }
    print STDERR "Any gap in columns: ", @gap_columns, "\n" if $debug;
}
else {
    ## Remove gap-only columns
    for (my $i = 0; $i < $length ; $i++) {
        my @column = ();
        foreach my $tax (keys %seq_hash) {
            push ( @column, $seq_hash{$tax}->[$i] );
        }
        if (@column == grep { $_ eq $gap } @column) { # all equal and all gaps
            push @gap_columns, $i;
        }
    }
    print STDERR "All-gaps in columns: ", @gap_columns, "\n" if $debug;
}

## Check if any gaps where found
if(scalar(@gap_columns) > 0) {
    my $p = scalar(@gap_columns);
    print STDERR "removing $p positions, " if $verbose;
    foreach my $name (@names) {
        foreach my $pos (@gap_columns) {
            $seq_hash{$name}->[$pos] =~ s/\S//;
        }
    }
}

## Print sequences
if ($outfile) {
    open $PRINT_FH, ">", $outfile or die "Could not open outfile for writing: $! \n";
    print STDERR "writing $outfile\n" if $verbose;
}

foreach my $name (@names) {
    print $PRINT_FH ">$name\n";
    my $seq = join( '', @{$seq_hash{$name}} );
    $seq =~ s/\S{80}/$&\n/g;
    print $PRINT_FH "$seq\n";
}

if ($outfile) {
    close $PRINT_FH;
}

exit(0);

