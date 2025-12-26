module CustomLogs
  class Logger
    class << self

      @@options = nil

      def write(hash)
        Socket.write(filter(hash))
      end

      def filter(hash)

        # truncate long and not strings values
        if options[:include_params]
          hash[:params] = truncate_hash(hash[:params], options[:truncate_length], options[:truncate_value]).to_json
        else
          hash.delete(:params)
        end

        "#{hash.to_json}"

      end

      def options
        @@options ||= ParseConfig.get
      end

      def truncate_hash(hash, length, truncate_value)
        new_hash = {}

        hash.to_hash.each_pair do |key, value|
          if value.blank?
            new_hash[key] = ''
          elsif value.instance_of? String
            new_hash[key] = value.truncate(length)
          elsif value.instance_of? Hash
            new_hash[key] = truncate_hash(value, length, truncate_value)
          else
            # we don't include key when value is not String
            # new_hash[key] = truncate_value
          end
        end

        new_hash
      end

      def dump_users(resource)
        Socket.write({users: resource.all}.to_json)
      end

    end
  end
end

