class ConfigStore
  @@defaults_path = File.join(File.dirname(__FILE__),'../config/defaults.json')
  @@overrides_path = File.expand_path('~/.config/api_deploy_overrides.json')

  def self.defaults_path
    @@defaults_path
  end

  def self.defaults_path=(path)
    @@defaults_path = path
  end

  def self.overrides_path
    @@overrides_path
  end

  def self.overrides_path=(path)
    @@overrides_path = path
  end

  def self.load_config
    warn "ConfigStoreuration overrides file not present at #{overrides_path}" unless File.exists?(overrides_path)
    defaults = Hashie::Mash.new(JSON.parse(File.read(defaults_path))) if File.exists?(defaults_path)
    overrides = JSON.parse(File.read(overrides_path)) if File.exists?(overrides_path)
    defaults.deep_merge(overrides || {})
  end

  class << self
    def teamcity; @@ConfigStore.teamcity; end
    def artifactory; @@ConfigStore.artifactory; end
    def octopus; @@ConfigStore.octopus; end
    def bitbucket; @@ConfigStore.bitbucket; end
  end

  def self.set_config
    @@ConfigStore = self.load_config
  end

  self.set_config
end
