require 'acts_as_explorable/element/base'
require 'acts_as_explorable/element/in'
require 'acts_as_explorable/element/sort'
require 'acts_as_explorable/element/dynamic_filter'

module ActsAsExplorable
  module Element
    attr_accessor :query_type, :model, :parameters, :query_string, :query_parts,
                  :full_query

    #
    # This method acts as a factory to build a concrete element
    #
    # @example
    #   ActsAsExplorable::Element.build(:in, 'Zlatan in:first_name', Player)
    #
    # @param type [Symbol] The element type to be build
    # @param query [String] The query string
    # @param model [ActiveRecord::Base] Anactive record model
    #
    # @return [ActsAsExplorable::Element] A concrete element type
    def self.build(type, query, model)
      klass = Module.nesting.last.const_get('Element').const_get(type.to_s.camelize)
      instance = klass.new(query, model, type)
      rescue NameError
        DynamicFilter.new(query, model, type)
    end

    def initialize(query, model, element_type = nil)
      query = query.to_acts_as_explorable(ActsAsExplorable.filters.keys)

      @type = element_type if element_type
      @model = model
      @query_string = query[:values]
      @query_parts = []
      filter_parameters(query[:params])
      after_init

      render if @parameters.present?
    end

    def after_init; end

    def execute(query_object)
      query_object.send(@query_type, @full_query)
    end

    protected

    def filter_parameters(params)
      return unless params[type]
      @parameters = params[type].select do |f|
        filters.find do |e|
          /#{e.to_sym}(?:-\w+)?/ =~ f
        end
      end
    end

    #
    # Returns the Arel table for the current model
    #
    # @return [Arel::Table] Arel table for the current model
    def table
      @model.arel_table
    end

    def render
      fail "`#render` needs to be implemented for #{self.class.name}"
    end

    def type
      @type.to_sym || self.class.name.demodulize.underscore.to_sym
    end

    #
    # Returns the customized filters
    #
    # @return [Hash] The customized filters
    def filters
      ActsAsExplorable.filters[type]
    end
  end
end
