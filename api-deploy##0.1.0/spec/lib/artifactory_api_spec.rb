require 'spec_helper'

describe ArtifactoryApi do
  let(:artifactory) { described_class.new }

  it 'configures the api endpoint' do
    expect(artifactory.api.endpoint).to eq('http://artifactory.yoox.net/artifactory')
    expect(artifactory.api.username).to eq('continuous_integration')
  end
end
