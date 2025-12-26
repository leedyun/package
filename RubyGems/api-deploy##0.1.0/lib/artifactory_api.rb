class ArtifactoryApi
  include Artifactory::Resource
  attr_reader :api

  def initialize
    @api = Artifactory::Client.new(
      endpoint: ConfigStore.artifactory.url,
      username: ConfigStore.artifactory.user,
      password: ConfigStore.artifactory.pass
    )
  end

end
