module AttributeNormalizer
  module Normalizers
    module SpacelessNormalizer
      def self.normalize(value, options)
        GsubNormalizer.normalize value, pattern: /\s+/, replacement: ''
      end
    end
  end
end
