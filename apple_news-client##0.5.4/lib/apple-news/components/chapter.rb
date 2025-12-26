require 'apple-news/components/container'

module AppleNewsClient
  module Component
    class Chapter < Container
      role "chapter"
      optional_property :scene, nil, Scene, :factory
    end
  end
end
