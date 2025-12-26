require 'support/xml_mapping/money_node'
require 'support/xml_mapping/datetime_node'
require 'support/xml_mapping/value_array_node'
require 'support/xml_mapping/cdata_node'
require 'support/xml_mapping/time_node'

XML::Mapping.add_node_class MoneyNode
XML::Mapping.add_node_class DatetimeNode
XML::Mapping.add_node_class ValueArrayNode
XML::Mapping.add_node_class CdataNode
XML::Mapping.add_node_class TimeNode

module XML
  module Mapping
    module ClassMethods
      # Base on original method
      def load_from_xml(xml, options={:mapping=>:_default})
        raise(MappingError, "undefined mapping: #{options[:mapping].inspect}") \
          unless xml_mapping_nodes_hash.has_key?(options[:mapping]) || 
            (superclass && superclass.xml_mapping_nodes_hash.has_key?(options[:mapping]))
        # create the new object. It is recommended that the class
        # have a no-argument initializer, so try new first. If that
        # doesn't work, try allocate, which bypasses the initializer.
        begin
          obj = self.new
        rescue ArgumentError # TODO: this may hide real errors.
                             #   how to statically check whether
                             #   self self.new accepts an empty
                             #   argument list?
          obj = self.allocate
        end
        obj.initialize_xml_mapping :mapping=>options[:mapping]
        obj.fill_from_xml xml, :mapping=>options[:mapping]
        obj
      end
    end
  end
end
