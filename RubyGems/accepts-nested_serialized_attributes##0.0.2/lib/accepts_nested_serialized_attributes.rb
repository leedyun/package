require "accepts_nested_serialized_attributes/version"

module AcceptsNestedSerializedAttributes
  module ActiveModel::Serialization
    alias_method :original_serializable_hash, :serializable_hash

    def serializable_hash(options = nil)
      original_serializable_hash(options).tap do |hash|
        hash.symbolize_keys!

        self.class.nested_attributes_options.keys.each do |nested_attributes_key|
          if (records = hash.delete nested_attributes_key)
            hash["#{nested_attributes_key}_attributes".to_sym] = records
          end
        end
      end
    end
  end
end
