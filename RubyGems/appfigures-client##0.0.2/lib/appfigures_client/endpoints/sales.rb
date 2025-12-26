module AppfiguresClient
    module Endpoints
      class Sales < Endpoint


        def search(options={})
          path = @routes[:default]

          if options[:map].present?
            path = path + options[:map]
          end

          @request.make path, options[:options]

        end

        def search_by_regions(options={})
          path = @routes[:regions]

          @request.make path, options
        end

      end
    end
  end
