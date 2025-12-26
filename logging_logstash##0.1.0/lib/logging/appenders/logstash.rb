module Logging
  module Appenders
    def self.logstash(*args)
      return Logging::Appenders::Logstash if args.empty?
      Logging::Appenders::Logstash.new(*args)
    end

    # This class provides an Appender that can write to remote syslog.
    #
    class Logstash < Logging::Appender
      ID_REG_EXP=/_id$/

      def self.num_to_level(level_num)
        @level_nums ||= Loggin::LEVELS..inject({}) do |hash, kv|
          hash[kv[1]] = kv[0]; hash
        end
        @level_nums[level_num]
      end

      # call:
      #    Logstash.new( name, opts = {} )
      #
      # Create an appender that will log messages to logstash. The
      # options that can be used to configure the appender are as follows:
      #
      # it accepts all options of logstash logger: https://github.com/dwbutler/logstash-logger
      #
      def initialize(name, opts = {})
        @host=opts.delete(:host) || Socket.gethostname
        @logstash_device=LogStashLogger::Device.new(opts)
        super
      end


      private

      # to have a good entry point for testing
      attr_reader :logstash_device

      # call:
      #    write( event )
      #
      # The trick is, that logging accepts all kind of objects to be logged. They are in
      # the event.data and are raw (not turned into strings).
      #
      def write(event)
        ls_event= data2logstash_event(event)

        logstash_device.write(ls_event.to_json+"\n")
        logstash_device.flush
        self
      end

      def data2logstash_event(logging_event)
        stash_event=if logging_event.data.kind_of?(Hash)
                      LogStash::Event.new(logging_event.data.dup)
                    else
                      LogStash::Event.new("message" => msg2str(logging_event.data))
                    end

        stash_event['@severity'] ||= ::Logging::LNAMES[logging_event.level]
        stash_event['@host'] ||= @host
        stash_event['@log_name'] ||= @name

        #context values don't override given values
        Logging.mdc.context.each do |key, value|
          stash_event[key] ||= value
        end

        Logging.ndc.context.each do |ctx|
          if ctx.respond_to?(:each)
            ctx.each do |key, value|
              stash_event[key] ||= value
            end
          else
            stash_event[ctx] ||= true #
          end
        end

# In case Time#to_json has been overridden
        if stash_event.timestamp.is_a?(Time)
          stash_event.timestamp = stash_event.timestamp.iso8601(3)
        end
        

        stash_event.to_hash.each do |key,value|
          if key =~ ID_REG_EXP
            stash_event[key]=value.to_s
          end
        end
        
        stash_event
      end

      def msg2str(msg)
        case msg
          when ::String
            msg
          when ::Exception
            "#{ msg.message } (#{ msg.class })\n" <<
                (msg.backtrace || []).join("\n")
          else
            msg.inspect
        end
      end


    end # Logstash
  end # Appenders
end #Logging