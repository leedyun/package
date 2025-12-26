module AppfiguresClient
    module Endpoints
      class Products < Endpoint

        FILTERS = %w(mac ios google amazon)

        def get(id)
          path = @routes[:default] + id.to_s
          @request.make path
        end

        def search(options={})
          path = @routes[:search]

          raise '"term" option is required' unless options[:term].present?

          if options[:options].present? && options[:options][:filter].present?
            raise 'Wrong "filter" param' unless options[:options][:filter].in? FILTERS
          end

          @request.make path + options[:term], options[:options]
        end

        def all(store = nil)
          path = @routes[:mine]
          options = nil
          if store && @api.data.stores[store].present?
            options = {store: store}
          end
          @request.make path, options
        end

      end
    end
  end
