# The following will print out the filename and md5 digest of all the
# files passed to it on the command line:
require 'digest/md5'
digest = Digest::MD5.hexdigest(File.read(f))
