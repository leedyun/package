require 'fileutils'

FileUtils.touch '../testdata/src_dir/file1.mmd'
FileUtils.rm_rf '../testdata/target_dir/file4.html'
FileUtils.rm_rf '../testdata/target_dir/images'
FileUtils.rm_rf '../testdata/target_dir_static'
