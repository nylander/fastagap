# Fastagap - Report, remove, or replace missing data in fasta

## Description

Scripts for handling missing data (gaps) in fasta files.

- [`fastagap.pl`](#fastagap) General script for counting, removing, or replacing missing data in fasta formatted files.

- [`degap_fasta_alignment.pl`](#degap\_fasta\_alignment) Script for handling "aligned" fasta format (sequences of same length).

- [`plot_missing_data.R`](#plot\_missing\_data) Script for plotting a heatmap of the output from `fastagap.pl -c -H *.fas`.

See below for description.

## Installation

The script [`fastagap.pl`](#fastagap) requires [perl](https://www.perl.org/) with perl
module [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils).

On a Debian-based Linux system, the module can be installed using `sudo apt
install -y liblist-moreutils-perl`.  The script `degap_fasta_alignment.pl` uses
standard perl modules, so no extra steps are required.

The script `fastagap.pl` can also be installed (as `fastagap`) using
[conda](https://docs.conda.io/en/latest/) from the [bioconda
channel](https://bioconda.github.io/).

    $ conda install -c bioconda fastagap

The script `plot_missing_data.R` requires `R` with R-packages `ggplot2`, `tidyr`.
For installation, see instructions on <https://cran.r-project.org/>.

## Usage

### fastagap

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

                  Convert fasta to tab-separated output

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

### degap\_fasta\_alignment

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

### plot\_missing\_data

             FILE: plot_missing_data.R

            USAGE: ./plot_missing_data.R [-h[--help] infile.tsv

      DESCRIPTION: Plots a heatmap showing amounts of missing data
                   per locus.

           OUTPUT: Heatmap-figure in PDF fomat with file ending `.missing_data.pdf`

          OPTIONS:
                   -h,--help Show help text

## Summary counts for many files

The script `fastagap.pl` can be used on several input files containing, e.g.,
different genes for the same samples (fasta headers):

    $ fastagap.pl -c -H *.fas

This output can be summarized in different ways. For example, say that you have
a number of separate gene files with a varying number of sequences, a quick
count of genes per taxon (fasta header) can be given by (using GNU awk):

    $ fastagap.pl -c -H *.fas | \
        awk 'BEGIN{printf("label\tcount\t%\n")}
             {L[$1]++;F[$NF]++}
             END{for(l in L){printf("%s\t%s\t%s\n",l,L[l],L[l]/length(F))}}'

Similarly, to count the number of taxa (fasta labels) per gene:

    $ fastagap.pl -c -H *.fas | \
        awk 'BEGIN{printf("file\tcount\t%\n")}
        {L[$1]++;F[$NF]++}
        END{for(f in F){printf("%s\t%d\t%.2f\n",f,F[f],F[f]/length(L))}}'

Furthermore, to get a visual image of the  "completeness", or amount of missing
data for each sample, a heatmap can be useful (see Fig. 1):

    $ fastagap.pl -c -H *.fas > counts.tsv
    $ plot_missing_data.R counts.tsv

![Heatmap showing missing data per sample for 352 loci.](img/counts.tsv.missing_data.png)

