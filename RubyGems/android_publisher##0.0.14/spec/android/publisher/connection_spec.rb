require 'spec_helper'

describe Android::Publisher::Connection do
  API_URL = 'https://www.googleapis.com/androidpublisher/v2/applications/com.package.name'

  let(:auth_connection) { double('OAuth2')}
  let(:publisher)       { described_class.new(auth_connection, "com.package.name") }

  describe '#get' do
    it 'should send a :get request' do
      auth_connection.
        should_receive(:get).
          with("#{API_URL}/endpoint")

      publisher.get("endpoint")
    end

    it 'should send correct request without parameters' do
      pub = publisher.add_endpoint('apks')
      auth_connection.
        should_receive(:get).
        with("#{API_URL}/apks/")

      pub.get
    end
  end

  describe '#post' do
    it 'should send a :post request' do
      auth_connection.
        should_receive(:post).
        with("#{API_URL}/endpoint", {})

      publisher.post("endpoint", {})
    end
  end

  describe '#delete' do
    it 'should send a :delete request' do
      auth_connection.
        should_receive(:delete).
        with("#{API_URL}/endpoint")

      publisher.delete("endpoint")
    end
  end

  describe '#patch' do
    it 'should send a :patch request' do
      auth_connection.
        should_receive(:patch).
        with("#{API_URL}/endpoint", {})

      publisher.patch("endpoint", {})
    end
  end


  describe '#append path' do
    it 'shoud remove trailing "/" from the endpoint'  do
      result = "#{API_URL}/endpoint"
      publisher.send(:append, "/endpoint").should == result
    end
    it 'should not modify other parts of path'  do
      result = "#{API_URL}/endpoint/whatever/whenever/"

      publisher.send(:append, "/endpoint/whatever/whenever/").should == result
    end
    it 'should create valid uris' do
      result = "#{API_URL}/endpoint/whatever/whenever/index.html?foo=bar"

      publisher.send(:append, "/endpoint/whatever/whenever/index.html?foo=bar").should == result
    end

    it 'should add endpoints' do
      pub = publisher.add_endpoint('edits')
      result = "#{API_URL}/edits/whatever/whenever/index.html?foo=bar"
      pub.send(:append, "whatever/whenever/index.html?foo=bar").should == result
    end
  end
end
