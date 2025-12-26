require 'active_record'
require 'json'

module ActiveRecord
  class SerializeJSON
    require 'active_record/serialize_json/version'

    def initialize(attribute, opts = {})
      @attribute = attribute.to_s.to_sym
      @serialize = opts[:serialize] || {}
      @deserialize = opts[:deserialize] || {}
    end

    attr_reader :attribute

    def before_save(record)
      json = serialize record
      a = @attribute
      record.instance_eval { write_attribute(a, json) }
    end

    def after_save(record)
      data = deserialize record
      a = @attribute
      record.instance_eval { write_attribute(a, data) }
    end

    def serialize(record)
      self.class.serialize(record.read_attribute(@attribute), @serialize)
    end

    def deserialize(record)
      self.class.deserialize(record.read_attribute(@attribute), @deserialize)
    end

    def self.serialize(value, opts = {})
      opts ||= {
        :max_nesting => false,
        :allow_nan   => true,
        :quirks_mode => true,
      }
      result = JSON(value, opts)
      result =~ /\A\s*[{\[]/ and result
    end

    def self.deserialize(value, opts = {})
      opts ||= {
        :max_nesting => false,
        :allow_nan   => true,
        :quirks_mode => true,
      }
      if value.to_s.strip.empty?
        nil
      else
        JSON.parse(value, opts)
      end
    rescue => e
      if defined?(::Rails)
        ::Rails.logger.warn e
      else
        warn "#{e.class}: #{e}"
      end
      value
    end
  end

  class Base
    def self.serialize_json(attribute, opts = {})
      sj = SerializeJSON.new(attribute, opts)

      after_save  sj
      before_save sj

      unless respond_to?(:serialize_json_attributes)
        cattr_accessor :serialize_json_attributes
        self.serialize_json_attributes = {}
      end
      serialize_json_attributes[sj.attribute] = sj

      if ::ActiveRecord::VERSION::MAJOR >= 3
        class_eval do
          after_find do |record|
            serialize_json_attributes.each do |attribute, sj|
              record.instance_eval do
                write_attribute(attribute, sj.deserialize(record))
              end
            end
          end
        end
      else
        class_eval do
          define_method(:after_find) do
            super if defined? super
            self.class.serialize_json_attributes.each do |attribute, sj|
              write_attribute(attribute, sj.deserialize(self))
            end
          end
        end
      end
    end
  end
end
