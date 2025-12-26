# encoding: utf-8
require "logstash/codecs/base"
require "logstash/namespace"

class LogStash::Codecs::Bytes < LogStash::Codecs::Base

  # This codec will chunk input into parts of a
  # specified length
  #
  # input {
  #   file {
  #     delimiter => ""
  #     codec => bytes {
  #       length => X
  #     }
  #   }
  # }

  config_name "bytes"

  config :length, :validate => :number, :required => true

  public
  def register
    @payload = []
  end

  public
  def decode(data)
    @payload += data.bytes.to_a

    while @payload.length >= @length
      line = @payload.slice!(0...@length).pack('c*')

      yield LogStash::Event.new({ "message" => line })
    end

  end

end
