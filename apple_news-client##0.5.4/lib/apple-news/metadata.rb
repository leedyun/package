module AppleNewsClient
  class Metadata
    include Properties
    optional_properties :authors, :campaign_data, :canonical_url, :date_created,
                        :date_modified, :date_published, :excerpt, :generator_identifier,
                        :keywords, :thumbnail_url, :video_url

    optional_property :generator_name, "apple-news-rb"
    optional_property :generator_version, AppleNewsClient::VERSION
    optional_property :transparent_toolbar, false
    optional_property :links, {}

    property_inflection :canonical_url, 'canonicalURL'
    property_inflection :thumbnail_url, 'thumbnailURL'
    property_inflection :video_url, 'videoURL'
  end
end
