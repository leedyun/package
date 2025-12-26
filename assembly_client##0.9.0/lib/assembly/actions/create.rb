module Assembly
  module Actions
    module Create
      module ClassMethods
        def create(args, client=Assembly.client)
          response = client.post(path, args)
          Util.build(response, client)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end