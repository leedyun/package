module AdvisorsCommandClient
  module Models
    class Base
      include Virtus.model

      def self.load(hash, connection = nil)
        hash = deep_underscore_params(hash)
        new(hash, connection)
      end

      def initialize(args, connection = nil)
        super(args)
        @original_hash = args
        @connection = connection
      end

      #JSON comes back as SnakeCase.
      #This will convert all hash keys to snake_case.
      def self.deep_underscore_params(val = {})
        snake_caser = -> val {val.to_s.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase}

        case val
        when Array
          val.map { |v| deep_underscore_params(v) }
        when Hash
          val.keys.each do |k, v = val[k]|
            val.delete k
            val[snake_caser.call(k)] = deep_underscore_params(v)
          end
          params = val
        else
          val
        end

        return val
      end
    end
  end
end