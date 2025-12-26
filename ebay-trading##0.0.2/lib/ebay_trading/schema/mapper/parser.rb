require 'xsd/qname'
require 'xsd/ns'
require 'xsd/charset'
require 'xsd/datatypes'
require 'xsd/xmlparser'
require 'wsdl/xmlSchema/parser'

module EbayTrading
  module Schema
    class Parser
      def self.parse(string_or_readable)
        WSDL::XMLSchema::Parser.new.parse(string_or_readable)
      end
    end
  end
end