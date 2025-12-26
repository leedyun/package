require_relative '../../bin/pub'
require 'logger'
require 'optparse'
require_relative '../it_tools/test_publisher2_support'
require_relative '../../lib/it_tools/pub_driver'

src_dir = '/home/fenton/projects/documentation'
dest_dir = '/home/fenton/bin/website'
stat_dir = '/home/fenton/bin/website_static'

# src_dir =  '/home/fenton/projects/beta_tools/testdata/publish/src_dir'
# dest_dir = '/home/fenton/projects/beta_tools/testdata/publish/target_dir'
# stat_dir = '/home/fenton/projects/beta_tools/testdata/publish/target_dir_static'

#support = PublisherSupport.new
#support.before src_dir

ARGV[0] = '-s'
ARGV[1] = src_dir
ARGV[2] = '-w'
ARGV[3] = dest_dir
ARGV[4] = '-t'
ARGV[5] = stat_dir
ARGV[6] = '-d'
ARGV[7] = 'debug'

pub = PubDriver::Pub.new
pub.all

# support.after [dest_dir, stat_dir]
