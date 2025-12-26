# Cat::Dog

Laughably simple script to partner with 'cat'

Where 'cat' takes a filename and sends its contents to stdout.  'dog' takes stdin and redirects it into a file.  Providing the other encap to a unix io stream.

Completely unnecessary under usual circumstances as unix command line io redirection
is usually sufficient for any such needs. Yet I have found the rare circumstance where 
such a command is handy. Usually in testing other command line scripts.

## Installation

$ gem install cat-dog

## Usage

cat file | dog otherfile

