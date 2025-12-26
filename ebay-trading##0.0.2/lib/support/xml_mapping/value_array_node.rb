require 'xml/mapping/base'

class ValueArrayNode < XML::Mapping::ArrayNode
  def initialize(*args)
  	*args = super(*args)
    @options[:marshaller] = proc{ |xml, value| xml.text = value }
    @options[:unmarshaller] = proc{ |xml| xml.text }
    args
  end
end
