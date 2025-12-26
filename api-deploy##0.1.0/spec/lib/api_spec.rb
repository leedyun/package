require 'spec_helper'

class ExampleAPI
  include API
end

describe API do
  let(:api) { ExampleAPI.new }
  let(:config) { double(:config, url: url) }
  let(:connection) { double(:connection) }
  let(:url) { 'http://example.com' }
  let(:query) { '{}' }

  context '#create_api' do
    context 'with an api key' do
      it 'creates a connection' do
        expect(config).to receive(:api_key).twice.and_return('foo')
        expect(api.create_api(config)).to be_an_instance_of(Faraday::Connection)
      end
    end

    context 'without an api key' do
      it 'creates a connection' do
        expect(config).to receive(:api_key).once.and_return(nil)
        expect(config).to receive(:user).once.and_return('foo')
        expect(config).to receive(:pass).once.and_return('bar')
        expect(api.create_api(config)).to be_an_instance_of(Faraday::Connection)
      end
    end
  end

  context '#request' do
    before do
      allow(api).to receive(:api).and_return(connection)
      allow(connection).to receive(:url_prefix).and_return(url)
    end

    context 'with query' do
      it 'sends the request with the params' do
        expect(connection).to receive(:post)
        api.request(:post, url, query)
      end
    end

    context 'without query' do
      it 'sends the request' do
        expect(connection).to receive(:post).with(url)
        api.request(:post, url)
      end
    end
  end
end
