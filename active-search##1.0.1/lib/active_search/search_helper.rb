require 'active_support/concern'

module ActiveRecord
  class Base
    def find_by_value(value, association)
      self.send(association.to_sym).find_by_value(value)
    end
    alias search_for find_by_value
  end
end

module ActiveSearch
  module SearchHelper
    extend ActiveSupport::Concern
    module ClassMethods
      def is_searchable?
        false
      end
      alias searchable? is_searchable?
      def searchable_by(*values)
        @searchable_values = values
        include ActiveSearch::IsSearchable
      end
      alias findable_by searchable_by
    end
  end
end
