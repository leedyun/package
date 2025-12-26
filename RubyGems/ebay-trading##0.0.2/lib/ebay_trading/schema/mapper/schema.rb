require 'mapper/parser'
require 'mapper/enumeration'
require 'mapper/enumeration_validation'
require 'mapper/node'
require 'mapper/ruby_class_generator_helper'
require 'mapper/ruby_class_generator'
require 'mapper/ebay_schema_importer'
require 'mapper/xsd2ebay'

module EbayTrading
  module Schema
	Namespace = 'urn:ebay:apis:eBLBaseComponents'
  end
end