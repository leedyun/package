module Assembly
  module Actions
    module Delete
      module ClassMethods
        def delete(id, client=Assembly.client)
          response = client.delete("#{path}/#{id}")
          true
        end
      end

      def delete
        client.delete(path)
        true
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end