module ActiveSearch
  module IsSearchable
    extend ActiveSupport::Concern
    module ClassMethods
      attr_reader :searchable_values
      def is_searchable?
        true
      end
      alias searchable? is_searchable?

      def find_by_value(value)
        values = []
        @searchable_values.each do |search|
         values << self.where("#{search} LIKE ?", "%#{value}%")
        end
        values.flatten
      end
      alias search_for find_by_value
    end
  end
end
