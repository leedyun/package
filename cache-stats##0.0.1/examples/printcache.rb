#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'cache_stats'

if ARGV.empty?
  puts "USAGE: #{$0} <file1> [<file2> ...]"
end

ARGV.each do |filename|
  stats = File.cache_stats filename
  print '['
  (0..stats.total_pages - 1).each do |page|
    print stats[page] ? 'X' : ' '
  end
  print '] '
  print "#{stats.cached_pages}/#{stats.total_pages}\n"
end
