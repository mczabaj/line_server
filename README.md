# line_server

generated using Luminus version "2.9.12.04"

FIXME

## Prerequisites

You will need [Leiningen][1] 2.0 or above installed.

[1]: https://github.com/technomancy/leiningen

## Running

To start a web server for the application, run:

    lein run

## License

Copyright © 2017 FIXME


## References

sample text files:
  https://www.ncl.ucar.edu/Applications/read_ascii.shtml#string1

https://www.skorks.com/2010/03/how-to-quickly-generate-a-large-file-on-the-command-line-with-linux/

generate sample file: run below by replacing X and Y with number lines (X) and number of words per line (Y).
  to generate a 100Mb file (try 1 million lines with 12 words per line)

ruby -e 'a=STDIN.readlines;*X*.times do;b=[];*Y*.times do; b << a[rand(a.size)].chomp end; puts b.join(" "); end' < /usr/share/dict/words > file1G.txt

{x: 10000, y: 5} = 500K file
{x: 300000, y: 8}= 250M file

(line-seq rdr)
Returns the lines of text from rdr as a lazy sequence of strings.
rdr must implement java.io.BufferedReader.
https://clojuredocs.org/clojure.core/line-seq


CD to root directory, run lein run (for local development)
