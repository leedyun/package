module Assembly
  class Resource
    def initialize(client)
      @client = client
    end

    def self.build(model_class)
      Assembly.const_set("#{model_class.class_name.split(':').last}Resource", resource_class_for(model_class))
    end

    def self.resource_class_for(model_class)
      Class.new(Assembly::Resource) do
        @model_class = model_class

        def self.model_class
          @model_class
        end

        def model_class
          self.class.model_class
        end

        if model_class.included_modules.include?(Assembly::Actions::Create)
          def create(params)
            model_class.create(params, @client)
          end
        end

        if model_class.included_modules.include?(Assembly::Actions::Read)
          def fetch(id, params={})
            model_class.fetch(id, params, @client)
          end
          alias_method :find, :fetch
        end

        if model_class.included_modules.include?(Assembly::Actions::List)
          def list(params={})
            model_class.list(params, @client)
          end

          def all(params={})
            model_class.all(params, @client)
          end

          def total_count(params={})
            model_class.total_count(params, @client)
          end
        end

        if model_class.included_modules.include?(Assembly::Actions::Update)
          def update(id, params)
            model_class.update(id, params, @client)
          end
        end

        if model_class.included_modules.include?(Assembly::Actions::Delete)
          def delete(id)
            model_class.delete(id, @client)
          end
        end

      end
    end
  end
end