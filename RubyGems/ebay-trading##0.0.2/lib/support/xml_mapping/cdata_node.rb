require 'xml/mapping/base'

class CdataNode < XML::Mapping::TextNode
  def initialize(*args)
  	super(*args)
    args 
  end

  def set_attr_value(xml, value) # :nodoc:
    @path.first(xml,:ensure_created => true).text = REXML::CData.new(value)
  end
end
