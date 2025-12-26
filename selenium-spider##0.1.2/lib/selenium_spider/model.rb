require 'selenium_standalone_dsl'
require 'json'

module SeleniumSpider
  class Model < SeleniumStandaloneDSL::Base
    attr_accessor :attributes
    @@attributes = {}

    def initialize(location: nil, driver: nil)
      if driver
         @driver = driver
      else
        super()
        visit location
      end
    end

    def set_attributes_value(key, value)
      @@attributes[key].value = value
    end

    def self.register(attr_name_sym)
      @@attributes[attr_name_sym] = SeleniumSpider::Attribute.new
      yield @@attributes[attr_name_sym] if block_given?
    end

    def extract(attr_name_sym)
      attr = @@attributes[attr_name_sym]
      return attr.value if attr.value

      element_str = search(attr.css).inner_text

      if attr.match &&(match = element_str.match(/#{attr.match}/))
        element_str = match[match.length - 1]
      end

      if attr.sub
        element_str = element_str.sub(/#{attr.sub[:replace]}/, attr.sub[:with])
      end

      if attr.lambda
        element_str = attr.lambda.call(element_str)
      end

      element_str
    end

    def extract_all
      extracted = {}
      @@attributes.each do |key, value|
        extracted[key] = extract(key)
      end
      extracted
    end

    # TODO: save to database(sqlite)
    def save
    end

    def output_as_json
      JSON.dump extract_all
    end
  end

  class Attribute
    attr_accessor :css, :match, :lambda, :sub, :value
  end
end

