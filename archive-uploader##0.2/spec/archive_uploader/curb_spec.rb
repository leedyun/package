require 'spec_helper'

describe ArchiveUploader::Curb do
  before :each do
    @tmpfile = Tempfile.new("foo")
    @url = "http://example.com/upload"
  end
  
  after :each do
    FileUtils.rm(@tmpfile)
  end
  
  it "sets @curl instance" do
    curb = ArchiveUploader::Curb.new(:url => @url, :file => @tmpfile)
    curb.instance_variable_get("@curl").should be_an_instance_of(Curl::Easy)
  end
  
  it "sets @options" do
    curb = ArchiveUploader::Curb.new(:url => @url, :file => @tmpfile)
    options = curb.instance_variable_get("@options")
    options[:url].should eql(@url)
    options[:file].should eq(@tmpfile)
  end
  
  describe "post data" do
    before :each do
      @fields = {:branch => "master", :commit => "12345abc"}
      @curb = ArchiveUploader::Curb.new(:url => @url, :file => @tmpfile, :fields => @fields)
      @data = @curb.post_data
    end
    
    it "returns file field as first argument" do
      file_field = @data.first
      file_field.should be_an_instance_of(Curl::PostField)
      file_field.name.should eql("file[file]")
      file_field.local_file.should eq(@tmpfile)
    end
    
    it "returns rest of fields" do
      @data.shift
      @fields.each_with_index do |(key, value), index|
        field = @data[index]
        field.should be_an_instance_of(Curl::PostField)
        field.name.should eql("file[#{key}]")
        field.content.should eql(value)
      end
    end
  end

  describe "auth data" do
    before :each do
      @fields = {:branch => "master", :commit => "12345abc"}
      @auth = OpenStruct.new(:_method => :basic, :user => "asdf", :password => "1234")
      @curb = ArchiveUploader::Curb.new(:url => @url, :file => @tmpfile, :fields => @fields, :auth => @auth)
    end

    it "sets auth vars to curl object" do
      @curl = @curb.instance_variable_get("@curl")
      @curl.http_auth_types.should eql(1)
      @curl.username.should eql("asdf")
      @curl.password.should eql("1234")
    end
  end
end
