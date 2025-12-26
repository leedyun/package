require 'spec_helper'

describe ConfigStore do
  let(:config) { described_class }
  let(:octopus_config) {{
    'url' => 'http://octopus3.yoox.net/api',
    'api_key' => 'test'
  }}
  let(:teamcity_config) {{
    'pass' => 'test',
    'url' => 'http://teamcity.yoox.net/httpAuth/app/rest',
    'user' => 'override',
  }}

  before(:all) do
    ConfigStore.defaults_path = 'spec/data/defaults.json'
    ConfigStore.overrides_path = 'spec/data/overrides.json'
    ConfigStore.set_config
  end

  context 'self.load_config' do
    it 'loads the defaults' do
      expect(config.octopus).to eq(octopus_config)
    end

    it 'loads the overrides' do
      expect(config.teamcity).to eq(teamcity_config)
    end
  end
end
