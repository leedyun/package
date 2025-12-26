require 'active_support/concern'
require "active_model/permalink/version"

module ActiveModel
  module Permalink
    
    CANDIDATE_SOURCE_ATTRIBUTES = [:name, :title]
    
    extend ActiveSupport::Concern
    
    included do
      before_validation :ensure_permalink_is_present
    end

  private

    def ensure_permalink_is_present
      self.permalink ||= generate_permalink
    end
    
    def generate_permalink
      source_attribute = ActiveModel::Permalink::CANDIDATE_SOURCE_ATTRIBUTES.detect do |attr|
        self.respond_to?(attr) && self.send(attr).present?
      end
      
      if source_attribute
        self.send(source_attribute).dasherize.parameterize
      else
        ''
      end
    end
  end
end
