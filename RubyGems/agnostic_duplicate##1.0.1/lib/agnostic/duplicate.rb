require 'agnostic/duplicate/version'

module Agnostic
  # Duplicate objects are provided with an additional method `duplicate` that
  # extends the method `dup` functionality.
  #
  # ## When to use
  #
  # The advantage of using Duplicate module reside in support for fields that
  # are not duplicated by default for any reason. Example: when using Rails
  # `dup` implementation doesn't copy attributes of model that return an
  # ActiveRecord::Relation, it is supossed the developer to choose his strategy.
  #
  # ## Usage
  #
  # When using `Duplicate` you specify a list of attributes that you want to be
  # copied additionaly to the object returned by `dup`. Though if `dup` returns
  # a value for an attribute and you mark that attribute as "duplicable" then
  # the value of the attribute will be overwritten with the value provided by
  # `duplicate` call.
  #
  # Example:
  #
  # ```ruby
  #  class Story < ActiveRecord::Base
  #    include Duplicate
  #    # ...
  #    attr_duplicable :seo_element, :category, :properties
  #    # ...
  #    attr_accessible :title
  #    # ...
  #    has_one :seo_element, as: :metadatable
  #    has_one :category, through: :categorisation, source: :category
  #    has_many :properties, :images, :headlines
  #    # ...
  #  end
  # ```
  #
  # When using `duplicable` over any attribute, it verifies if the current value
  # value implements `Duplicate`. In that case it returns the result of calling
  # to `duplicate` on that object. If the attribute doesn't implement
  # `Duplicate` it is returned the `dup` value.
  #
  # If the `duplicable` attribute is iterable then it is returned an array where
  # every element of the collection is duplicated following the flow defined
  # previously.
  #
  # Also it is possible to provide **shallow copies** of attribute values,
  # modifying the default behaviour. In that case, just make use of the
  # `strategy` option.
  #
  # ```ruby
  #   attr_duplicable :images, strategy: :shallow_copy
  # ```
  #
  # It is given support for custom behaviour after duplication process. In that
  # case it is only required to implement the method `hook_after_duplicate!`
  #
  # Extending previous example:
  #
  # ```ruby
  #  def hook_after_duplicate!(duplicate)
  #    duplicate.headlines = self.headlines.not_orphans.collect(&:dup)
  #    duplicate.images.each { |img| img.attachable = duplicate }
  #  end
  # ```
  #
  # **ATENTION:** Observe that `model` passed as parameter is in fact the
  # duplicated instance that it is going to be returned
  #
  # ## Configuration options
  #
  # If the only attribute values you want to be duplicated are the ones you have
  # specified through the `attr_duplicable` method, and though removing the
  # additional fields duplicated because of the init call to `dup`, then you can
  # set this configuration through `duplicable_config` method:
  #
  # ```ruby
  #  class Image < ActiveRecord::Base
  #    include Duplicate
  #    duplicable_config new_instance: true
  #    # ...
  #    attr_duplicable :images
  #    # ...
  #  end
  # ```
  #
  # If you want to apply the `duplicate` over a custom instance object instead
  # of the default template for the current configuration, then you can pass a
  # `dup_template` option on the method call
  #
  # ```ruby
  # otherobject  # => Object sharing duplicable attributes with 'myobject'
  # myobject.duplicate dup_template: otherobject
  # ```
  #
  # As the object passed to dup_template should be compliant with the duplicable
  # attribute list, if there is an error during the process an exception will
  # be raise according to the type of error:
  #   - Agnostic::Duplicate::ChangeSet::AttributeNotFound
  #   - Agnostic::Duplicate::ChangeSet::CopyError
  #
  module Duplicate
    def self.included(base)
      base.extend(ClassMethods)
      base.instance_variable_set '@duplicable_changesets', []
      base.instance_variable_set '@duplicable_options', {}
    end

    # Duplicates the object
    # @return [Duplicate] the new instance object
    # @return opts [Hash] the options for duplicating
    # @option [Object] dup_template The object over attributes are going to be
    #   copied
    def duplicate(opts = {})
      (opts[:dup_template] || dup_template).tap do |model|
        apply_changesets!(model)
        hook_after_duplicate!(model) if respond_to? :hook_after_duplicate!
      end
    end

    private

    # Applies to model the duplicable changesets defined in class definition
    # @param model [Duplicate] the duplicated new instance object
    def apply_changesets!(model)
      self.class.duplicable_changesets.each do |changeset|
        changeset.apply(self, model)
      end
    end

    # Contains all kinds of changesets that can be applied to a duplicable
    # object
    module ChangeSet
      # Raised when there is an error while trying to copy an attribute
      class CopyError < StandardError
      end
      # Raised when a non existing attribute is tried to be duplicated
      class AttributeNotFound < StandardError
      end

      # Base class for all changesets. Subclasses should implement method
      # `apply` (see #apply)
      class Base
        attr_reader :attributes
        def initialize(attributes)
          @attributes = attributes
        end

        private

        def raise_copy_error_for(attribute)
          msg = "It wasn't possible to copy attribute '#{attribute}'"
          fail CopyError, msg, caller
        end
      end

      # Defines a changeset where a deep copy wants to be applied to all
      # attributes
      class DeepCopy < Base
        # Applies changes needed on the duplicated new instance object
        # @param parent [Duplicate] the original object to be duplicated
        # @param model [Duplicate] the duplicated new instance object
        def apply(parent, model)
          attributes.each do |attribute|
            unless model.respond_to? "#{attribute}="
              fail AttributeNotFound, "Attribute: '#{attribute}'", caller
            end
            deep_copy = dup_attribute(parent, attribute)
            copy_attribute(attribute, model, deep_copy)
          end
        end

        private

        # @param attribute [Symbol] attribute to be copied
        # @param parent [Duplicable] the original object to be duplicated
        # @param model [Duplicable] the duplicated new instance object
        def copy_attribute(attribute, model, deep_copy)
          model.send("#{attribute}=", deep_copy)
        rescue
          raise_copy_error_for(attribute)
        end

        # @param parent [Duplicate] the original object to be duplicated
        # @param attribute [Symbol] the attribute to be duplicated
        # @return from a duplicable object the duplicated value for the
        # attribute specified
        def dup_attribute(parent, attribute)
          value = parent.send(attribute)
          klass = self.class
          if value && value.respond_to?(:collect)
            value.map { |item| klass.dup_item(item) }
          else
            value && klass.dup_item(value)
          end
        end

        # Duplicates the object passed as parameter
        # @param item [Object] object to be duplicated
        # @return [Object] the duplicated new instance object
        def self.dup_item(item)
          if item.respond_to? :duplicate
            item.duplicate
          else
            item.dup
          end
        rescue
          item
        end
      end

      # Defines a changeset where a deep copy wants to be applied to all
      # attributes.
      #
      # Though if the field value is a memory address it copies the memory
      # address, and if the field value is a primitive type it copies the value
      # of the primitive type.
      class ShallowCopy < Base
        # Applies changes needed on the duplicated new instance object
        # @param parent [Duplicable] the original object to be duplicated
        # @param model [Duplicable] the duplicated new instance object
        def apply(parent, model)
          attributes.each do |attribute|
            copy_attribute(attribute, parent, model)
          end
        end

        private

        # @param attribute [Symbol] attribute to be copied
        # @param parent [Duplicable] the original object to be duplicated
        # @param model [Duplicable] the duplicated new instance object
        def copy_attribute(attribute, parent, model)
          model.send("#{attribute}=", parent.send(attribute))
        rescue
          raise_copy_error_for(attribute)
        end
      end
    end

    private

    # @return [Duplicable] a new instance object based on global duplicable
    #   configuration
    def dup_template
      klass = self.class
      if klass.duplicable_option? :new_instance
        klass.new
      else
        dup
      end
    end

    # Methods added to classes including Duplicable module
    module ClassMethods
      attr_accessor :duplicable_changesets, :duplicable_options

      # Adds a new duplicable changeset for the class.
      #
      # By default created changesets apply a deep copy strategy over the
      # attributes specified. If you want to set a shallow copy strategy then
      # you can add the option `strategy: :shallow_copy`
      #
      # @param *args [Array<Symbol>] a list of attribute names
      # @param options [Hash] options specific for the changeset
      def attr_duplicable(*args)
        @changeset_options = {}
        @changeset_options = args.pop if args.last.is_a? Hash
        duplicable_changesets << changeset_class.new(args)
      end

      # Sets global options for applying changesets
      #
      # @param opts [Hash] The options for duplicable configuration
      # @option opts [Boolean] :new_instance If `true` the duplicated instance
      #   is created calling in first place `new` method over the class. if
      #   `false` the duplicated instance is created calling to `dup` method
      #   over the instance object.
      def duplicable_config(opts)
        if opts.is_a? Hash
          @duplicable_options.merge! opts
          keep_valid_options
        else
          fail ArgumentError, 'Invalid options configuration'
        end
      end

      # @param option [Symbol] global option for duplication
      # @return [Boolean] the boolean value expressing if the option is
      # activated
      def duplicable_option?(option)
        @duplicable_options ||= {}
        @duplicable_options[option]
      end

      private

      # Remove unknown options for applying changesets
      def keep_valid_options
        @duplicable_options.keep_if { |key, _| [:new_instance].include? key }
      end

      # @return [ChangeSet::Object] based on the strategy of duplication to be
      # applied over the attributes
      def changeset_class
        strategy = @changeset_options[:strategy] || :deep_copy
        class_name = strategy.to_s.split('_').map(&:capitalize).join
        Duplicate.const_get('ChangeSet').const_get("#{class_name}")
      end
    end
  end
end
