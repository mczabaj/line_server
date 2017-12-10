# line_server

This is a simple API that has one route. GET "/lines/<:line-number>" will return
you the string from the file loaded to the application for that line number.
If your requested line number of "out of bounds", you will get a 413 error.

generated using Luminus version "2.9.12.04"

# Development
## Prerequisites

You will need [Leiningen][1] 2.0 or above installed.

[1]: https://github.com/technomancy/leiningen

## Running Locally

To start a web server for the application, cd to app root and run:

    lein run

Then, you can hit `localhost:3000/lines/:line-number`

Additionally, you can view the Swagger UI at `localhost:3000/swagger-ui`

Note, using `lein run` will start the application with a default 500kb file.

## Running from Container Image

To start, you will need a dockerhub account. Once you have one, you can pull base images, run the following:

  docker login

  make build

  make ...


## References

#### Creating yourself a massive file to test/run with:

Generate a sample file: run below by replacing X and Y with number lines and number of words per line, respectively.

  `ruby -e 'a=STDIN.readlines;*X*.times do;b=[];*Y*.times do; b << a[rand(a.size)].chomp end; puts b.join(" "); end' < /usr/share/dict/words > file1G.txt`

  {x: 10000, y: 5} = 500K file
  {x: 300000, y: 8} = 250G file
  {x: 1000000, y: 12} = 100M file

https://www.skorks.com/2010/03/how-to-quickly-generate-a-large-file-on-the-command-line-with-linux/

#### Lazy Loading the File

`(line-seq rdr)`

Returns the lines of text from rdr as a lazy sequence of strings.
rdr must implement java.io.BufferedReader.

https://clojuredocs.org/clojure.core/line-seq

## License

Copyright © 2017 Mike Czabj
