# BisearchEnzimHu

A colleague of mine comes to me and expose his work problem, she would like to automatize the following steps:

1. open the browser and connect to the [Primer design](http://bisearch.enzim.hu/?m=search) page of [Bisearch.enzim.hu](http://bisearch.enzim.hu/) site of Institute of Enzymology
2. filling the form:
  * paste a sequence like "ATTATCACA...tagtttctgcaa"
  * check 'Bisulfite'
  * set 'Opt' of 'Primer length' ('Primer scoring values' section) to 30
  * set 'Minimum of CpGs' ('Primer design' section) to 0
  * set 'Database' to 'Homo sapiens' ('Database search and fast PCR' section)
3. Push the "Search primers" button to submit the search
4. Wait about 30 seconds to get the 10 results
5. For each result push the 'FPCR' (FastPCR or PCR in silico), wait about 5 seconds to get the _level2_ result
6. Analyse the 'FPCR' result, and drop the one they have more than 1 product


So I build this gem that automatize all the tasks in a single request (a _Wrapper_):

```ruby
require 'bisearch_enzim_hu'

pd = BisearchEnzimHu::PrimerDesign.new
pd.sequence(seq, chr, start_pos).search
```



TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'bisearch_enzim_hu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bisearch_enzim_hu

## Usage

```ruby
require 'bisearch_enzim_hu'

chr = "chr17"
start_pos = 32305219
seq = "ATTATCACACTCAGGCCCTAGCTGCTAGAAGCCTCATTTGCCTAAGTTTTTGTCCCAATGTTTCCGTGAAGGCAGAGAGAGGAGCTATTTGCATGCCAGCCCAGGGCTACGTAGAAAATATGGCAGGGATCCTCTCACACTGCAGTCGAGTCAAGGCAGTCCAGGGTGGCTGctggggccagactgccccgtcaagatccagcctgcctttcactgactgtgtgattagaatgtcttgccctatccctggactttagtttctgcaa"

pd = BisearchEnzimHu::PrimerDesign.new
pd.sequence(seq, chr, start_pos).search # chr and start_pos are optional
File.open('result.yml', 'w') {|f| f.write pd.primers.to_yaml } # save the result (an hash) to a YAML file

pd.prune # remove from result the _multi products_ FPCR results
File.open('result_pruned.yml', 'w') {|f| f.write pd.primers.to_yaml }
```

## Contributing

1. Fork it ( https://github.com/iwan/bisearch_enzim_hu/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
