require 'spec_helper'

describe ArchiveUploader::CLI do
  it "returns list of directories when sent with -D" do
    @argv = ["-D", "spec,bin"]
    opts = ArchiveUploader::CLI.parse(@argv)
    opts.directories.should =~ ["spec", "bin"]
  end 

  it "returns list of directories when sent with -d" do
    @argv = ["-d", "spec", "-d", "bin"]
    opts = ArchiveUploader::CLI.parse(@argv)
    opts.directories.should =~ ["spec", "bin"]
  end

  it "sets auth.method to basic" do
    @argv = ["-a", "basic"]
    opts = ArchiveUploader::CLI.parse(@argv)
    opts.auth._method.should eql(:basic)
  end

  it "sets auth.user to root" do
    @argv = ["-u", "root"]
    opts = ArchiveUploader::CLI.parse(@argv)
    opts.auth.user.should eql("root")
  end

  it "sets auth.password to password" do
    @argv = ["-p", "asdf"]
    opts = ArchiveUploader::CLI.parse(@argv)
    opts.auth.password.should eql("asdf")
  end
end
