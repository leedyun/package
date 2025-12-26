module AppfiguresClient
    module Endpoints
      class Data < Endpoint

        def initialize(api, routes)
          super api, routes
          @data = {}
        end

        def list(param, param2 = nil)
          if param2
            @data[param] ||= {}
            @data[param][param2] ||= @request.make @routes[param][param2]
          else
            @data[param] ||= @request.make @routes[param]
          end
        end

        def categories
          list(:categories)
        end

        def countries(store = nil)
          list(:countries, store)
        end

        def languages
          list(:languages)
        end

        def currencies
          list(:currencies)
        end

        def stores
          list(:stores)
        end

      end
    end
  end

