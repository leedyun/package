module ActsAsExplorable
  module Explorable
    def self.extended(base)
      base.class_eval do
        def self.explorable?
          false
        end
      end
    end

    # Configure ActsAsExplorable's behavior in a model.
    #
    # The plugin can be customized using parameters or through a `block`.
    #
    #     class Player < ActiveRecord::Base
    #       extend ActsAsExplorable
    #       explorable in: [:first_name, :last_name, :position, :city, :club],
    #                  sort: [:first_name, :last_name, :position, :city, :club, :created_at],
    #                  position: ['GK', 'MF', 'FW']
    #     end
    #
    # Using a block (TODO: This will be available in future versions):
    #
    #     class Player < ActiveRecord::Base
    #       extend ActsAsExplorable
    #       explorable do |config|
    #         config.filters = {
    #           in: [:first_name, :last_name, :position, :city, :club],
    #           sort: [:first_name, :last_name, :position, :city, :club, :created_at],
    #           position: ['GK', 'MF', 'FW']
    #         }
    #       end
    #     end
    #
    # @yield Provides access to the model class's config, which
    #   allows to customize types and filters
    #
    # @yieldparam config The model class's {ActsAsExplorable::Configuration config}.
    def explorable(filters = {}, &_block)
      class_eval do
        def self.explorable?
          true
        end
      end

      if block_given?
        ActsAsExplorable.setup { |config| yield config }
      else
        explorable_set_filters filters
      end
    end

    protected

    # Configure ActsAsExplorable's permitted filters per type in a model.
    #
    #     class Person < ActiveRecord::Base
    #       extend ActsAsExplorable
    #       explorable_filters in: [:first_name, :last_name, :city],
    #                          sort: [:first_name, :last_name, :city, :created_at]
    #     end
    #
    # @param [Hash] filters Filters for types
    # @return [Array] Permitted filters
    #
    def explorable_set_filters(filters = {})
      ActsAsExplorable.filters = filters if filters.present?

      ActsAsExplorable.filters.each_pair do |f, _a|
        ActsAsExplorable.filters[f].map!(&:downcase)
      end

      ActsAsExplorable.filters
    end
  end
end
