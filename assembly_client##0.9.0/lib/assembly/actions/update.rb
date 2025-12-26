module Assembly
  module Actions
    module Update
      module ClassMethods
        def update(id, params, client=Assembly.client)
          response = client.put("#{path}/#{id}", params)
          Util.build(response)
        end
      end

      def update(params={})
        response = client.put(path, dirty_params.merge(params))
        self.update_from(response)
      end
      alias_method :save, :update

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end