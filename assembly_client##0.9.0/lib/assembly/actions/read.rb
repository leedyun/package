module Assembly
  module Actions
    module Read
      module ClassMethods
        def fetch(id, params={}, client=Assembly.client)
          raise ArgumentError.new("an id must be provided to fetch a record") if id.nil? || id.to_s.empty?
          response = client.get("#{path}/#{id}", params)
          Util.build(response, client)
        end
        alias_method :find, :fetch
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end