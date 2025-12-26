#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'httparty'

module GitlabQuality
  module TestTooling
    class LabelsInference
      WWW_GITLAB_COM_SITE = 'https://about.gitlab.com'
      WWW_GITLAB_COM_GROUPS_JSON = "#{WWW_GITLAB_COM_SITE}/groups.json".freeze
      WWW_GITLAB_COM_CATEGORIES_JSON = "#{WWW_GITLAB_COM_SITE}/categories.json".freeze

      def infer_labels_from_product_group(product_group)
        [groups_mapping.dig(product_group, 'label')].compact.to_set
      end

      def infer_labels_from_feature_category(feature_category)
        [
          categories_mapping.dig(feature_category, 'label'),
          *infer_labels_from_product_group(categories_mapping.dig(feature_category, 'group'))
        ].compact.to_set
      end

      private

      def categories_mapping
        @categories_mapping ||= self.class.fetch_json(WWW_GITLAB_COM_CATEGORIES_JSON)
      end

      def groups_mapping
        @groups_mapping ||= self.class.fetch_json(WWW_GITLAB_COM_GROUPS_JSON)
      end

      def self.fetch_json(json_url)
        json = with_retries { HTTParty.get(json_url, format: :plain) }
        JSON.parse(json)
      rescue JSON::ParserError
        Runtime::Logger.debug("#{self.class.name}##{__method__} attempted to parse invalid JSON:\n\n#{json}")
        {}
      end

      def self.with_retries(attempts: 3)
        yield
      rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError, Net::OpenTimeout
        retry if (attempts -= 1).positive?
        raise
      end
      private_class_method :with_retries
    end
  end
end
