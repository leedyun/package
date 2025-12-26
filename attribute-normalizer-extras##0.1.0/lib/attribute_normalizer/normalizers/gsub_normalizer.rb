module AttributeNormalizer
  module Normalizers
    module GsubNormalizer
      def self.normalize(value, options)
        value.is_a?(String) ? value.gsub(options[:pattern], options[:replacement]) : value
      end
    end
  end
end
