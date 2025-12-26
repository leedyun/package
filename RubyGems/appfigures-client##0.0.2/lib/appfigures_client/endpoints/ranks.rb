module AppfiguresClient
    module Endpoints
      class Ranks < Endpoint


        def search(options={})
          raise '"product_ids" option is required' unless options[:product_ids].present?
          raise '"granularity" option is required' unless options[:granularity].present?
          raise '"start_date" option is required' unless options[:start_date].present?
          raise '"end_date" option is required' unless options[:end_date].present?

          path = "#{@routes[:default]}#{product_ids(options[:product_ids])}"
          path +="/#{options[:granularity]}/#{options[:start_date]}/#{options[:end_date]}"

          @request.make path, options[:options]

        end

        def snapshots(options = {})
          raise '"time" option is required' unless options[:time].present?
          raise '"country" option is required' unless options[:country].present?
          raise '"category" option is required' unless options[:category].present?
          raise '"subcategory" option is required' unless options[:subcategory].present?

          path = "#{@routes[:snapshots]}#{options[:time]}"
          path +="/#{options[:country]}/#{options[:category]}/#{options[:subcategory]}"

          @request.make path, options[:options]
        end

        private

        def product_ids(product_ids)
           product_ids.kind_of?(Array) ? product_ids.join(';') : product_ids
        end

      end
    end
  end
