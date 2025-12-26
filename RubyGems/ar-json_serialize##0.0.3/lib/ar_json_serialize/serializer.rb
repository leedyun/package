module ArJsonSerialize
  module Serializer
    extend self

    def load(source)
      return '' unless source.present?
      result = parse_source(source)
      case result
      when ::Hash
        ::Hashie::Mash.new(result)
      when ::Array
        parse_array(result)
      else
        result
      end
    end

    def dump(source)
      ::MultiJson.dump(source)
    end

    private

    def parse_source(source)
      ::MultiJson.load(source)
    rescue
      source
    end

    def parse_array(result)
      result.map do |item|
        item.is_a?(::Hash) ? ::Hashie::Mash.new(item) : item
      end
    end
  end
end
