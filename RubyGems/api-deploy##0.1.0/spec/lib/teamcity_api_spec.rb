require 'spec_helper'

describe TeamcityApi do
  let(:api_url) { 'http://example.com' }
  let(:user) { 'user' }
  let(:pass) { 'pass' }

  let(:teamcity) { described_class.new(api_url, user, pass) }

  before do
  end

  it 'has a list of valid resource types' do
  end

  context '#create_resource' do
    it 'sends a post to octopus' do
    end
  end
end
