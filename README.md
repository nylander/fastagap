# fastagap - remove or replace gaps in fasta

Scripts for handling gaps (missing data) in fasta files.

General script: `fastagap.pl`

Script for "aligned" fasta format (sequences of same length): `degap_fasta_alignment.pl`.

See below for description.


## fastagap

              FILE: fastagap.pl

             USAGE: ./fastagap.pl [OPTIONS] fasta

       DESCRIPTION: Report or replace/remove missing-data characters in fasta.

                    Can identify and manipulate leading, trailing, and
                    inner gap regions.

                    Reads fasta-formatted files and writes to stdout as
                    fasta or tab-separated output.

                    Default behaviour (no options used) is to remove all
                    occurrences of missing data represented by the symbol
                    '-' from the sequences. If an "all-gap" sequence is
                    encountered, it will be excluded from output.

                    See OPTIONS and EXAMPLES for more details.

         EXAMPLES:  Remove all missing data ('-')

                        $ ./fastagap.pl data/missing.fasta

                    Count missing data

                        $ ./fastagap.pl -c data/missing.fasta

                    Count only 'N' as missing data

                        $ ./fastagap.pl -c -N data/missing.fasta

                    Remove all '?'

                        $ ./fastagap.pl -A -Q data/missing.fasta

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

                    Convert fasta to tab-separated output

                        $ ./fastagap.pl -tabulate data/missing.fasta

           OPTIONS:
                    -c, --count
                        Count and report. Do not print sequences.

                    -m, --missing=<string>
                        Character <string>, or Perl regex (experimental)
                        to use as missing symbol. Default is '-'.

                    -G
                        Set missing symbol to hyphen ('-').

                    -N
                        Set missing symbol to 'N' (case sensitive).

                    -Q
                        Set missing symbol to '?'.

                    -H, --no-header
                        Suppress printing of header in table output (use
                        together with '-c').

                    -A, --remove-all
                        Remove all missing symbols from sequences.

                    -L, --remove-leading
                        Remove all leading missing symbols from sequences.

                    -T, --remove-trailing
                        Remove all trailing missing symbols from sequences.

                    -I, --remove-inner
                        Remove all inner missing symbols from sequences.

                    -E, --remove-empty
                        Explicitly remove empty sequences, i.e., fasta entries
                        with header only.

                    -PA, --remove-allp=<integer>
                        Remove sequence if total amount of missing data exceeds
                        <percent>. That is, allow <integer> percent missing data.

                    -PL, --remove-leaingp=<integer>
                        Remove sequence if total amount of leading missing data
                        exceeds <integer> percent.

                    -PT, --remove-trailingp=<integer>
                        Remove sequence if total amount of missing trailing data
                        exceeds <integer> percent.

                    -PI, --remove-innerp=<integer>
                        Remove sequence if total amount of missing inner data 
                        exceeds <integer> percent.

                    -PLT, --remove-leadingtrailingp=<integer>
                        Remove sequence if the sum of leading- and trailing missing
                        data exceeds <integer> percent.

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

                    -v, --verbose
                        Print warnings when replacements are attempted on empty
                        sequences.

                    -w, --wrap=<nr>
                        Wrap fasta sequence to max length <nr>. Default is 60.

                    --tabulate
                        Print tab-separated output (header tab sequence).

                    -X
                        Shortcut for '-A -m='N|\-|\?' --noverbose'.

                    -h
                        Show brief help info.

                    --help
                        Show more help info.

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

                    To get tab-separated output instead of fasta, use '-tabulate'.

                    To get an easy view of the table output in a terminal window,
                    one could be helped by the program 'column':

                        $ ./fastagap.pl -c data/missing.fasta | column -t

            AUTHOR: Johan Nylander

           COMPANY: NRM/NBIS

           VERSION: 0.2b

           CREATED: Thu 14 maj 2020 16:27:24

          REVISION: Mon 18 maj 2020 17:07:22

           LICENSE: Copyright (c) 2019-2020 Johan Nylander

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


---

## degap_fasta_alignment

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

         REVISION: fre 15 maj 2020 13:06:49

          LICENSE: Copyright (c) 2019-2020 Johan Nylander

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
        
