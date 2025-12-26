#!/usr/bin/env ruby

require 'optparse'

options = {}

args = ARGV

command, *args = args
entity, *args = args

OptionParser.new do |opts|

  opts.banner = "Usage: bitmovin [options]"

  opts.on("-k", "--key", "api key") do |key|
    options[:key] = key
  end
end.parse!
p "#{command} #{entity}"
p options
