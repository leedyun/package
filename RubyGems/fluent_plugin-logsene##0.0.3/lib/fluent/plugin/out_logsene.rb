# encoding: UTF-8
require 'net/http'
require 'date'

class Fluent::LogseneOutput< Fluent::BufferedOutput
  Fluent::Plugin.register_output('logsene', self)

  config_param :host,     :string,  :default => 'logsene-receiver.sematext.com'
  config_param :port,     :integer, :default => 80
  config_param :path,     :string,  :default => ''
  config_param :logtype,  :string,  :default => 'syslog'
  config_param :format,   :string,  :default => 'json'

  include Fluent::SetTagKeyMixin
  config_set_default :include_tag_key, false

  include Fluent::SetTimeKeyMixin
  config_set_default :include_time_key, false

  def initialize
    super
  end

  def configure(conf)
    super
  end

  def start
    super
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def shutdown
    super
  end

  def write(chunk)
    messages = []
    
    case @format
      when 'json'
        chunk.msgpack_each do |tag, time, record|
          if @include_tag_key
            record.merge!(@tag_key => tag)
          end
          if @include_time_key
            record.merge!(@time_key => @timef.format(time))
          end
          messages << record.to_json
        end
      when 'text'
        chunk.msgpack_each do |tag, time, record|
          messages << record['message']
        end
    end

    http = Net::HTTP.new(@host, @port.to_i)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.set_debug_output $stderr

    request = Net::HTTP::Post.new(@path + "/" + @logtype)
    request.body = messages.join("\n")
    http.request(request)
  end
end
