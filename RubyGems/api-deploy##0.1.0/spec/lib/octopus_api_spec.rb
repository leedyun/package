require 'spec_helper'

describe OctopusApi do
  let(:api_url) { 'http://octopus3.yoox.net/api' }
  let(:api_key) { 'TESTKEY' }
  let(:type) { 'Test' }
  let(:id) { 'id' }
  let(:headers) {{ 'X-Octopus-ApiKey'=> api_key }}
  let(:create_query) {{ name: "new_box" }}
  let(:api) { double(:api, url_prefix: api_url) }

  let(:environments) {[
    {'Name' => 'Foo'},
    {'Name' => 'Bar'},
    {'Name' => 'Baz'},
  ]}

  let(:octopus) { described_class.new }

  before do
    expect(Faraday).to receive(:new).with(url: api_url).and_return(api)
  end

  it 'has a list of valid resource types' do
    expect(octopus.class::RESOURCE_TYPES.count).to eq(10)
  end

  context '#create_resource' do
    it 'sends a post to octopus' do
      expect(octopus).to receive(:check_type).with(type)
      expect(api).to receive(:post)
      octopus.create_resource(type, name: "new_box")
    end
  end

  context '#remove_resource' do
    it 'sends a delete to octopus' do
      expect(octopus).to receive(:check_type).with(type)
      expect(api).to receive(:delete).with("/#{type}/#{id}")
      octopus.remove_resource(type, id)
    end
  end

  context '#get_resource' do
    it 'sends a get to octopus' do
      expect(octopus).to receive(:check_type).with(type)
      expect(api).to receive(:get).with("/#{type}/all")
      octopus.get_resource(type)
    end
  end

  context '#check_type' do
    it 'raises an error unless type in list' do
      expect { octopus.check_type("Invalid type") }.to raise_error NameError
    end

    it 'does not raise an error if type in list' do
      expect { octopus.check_type(octopus.class::RESOURCE_TYPES.first) }.to_not raise_error
    end
  end

  context '#get_resource_by_type_and_name' do
    it 'returns all if no name given' do
      expect(octopus).
        to receive(:get_resource).
        with('Environments').
        and_return(environments)
      expect(octopus.get_resource_by_type_and_name('Environments')).to eq(environments)
    end

    it 'returns one if exact name filter given' do
      expect(octopus).
        to receive(:get_resource).
        with('Environments').
        and_return(environments)
      expect(octopus.get_resource_by_type_and_name('Environments', 'Foo')).to eq([environments.first])
    end

    it 'returns one if only part of name given' do
      expect(octopus).
        to receive(:get_resource).
        with('Environments').
        and_return(environments)
      expect(octopus.get_resource_by_type_and_name('Environments', 'az')).to eq([environments.last])
    end

    it 'returns all that match if only part of name given' do
      expect(octopus).
        to receive(:get_resource).
        with('Environments').
        and_return(environments)
      expect(octopus.get_resource_by_type_and_name('Environments', 'B')).to eq(environments[1..2])
    end
  end
end
