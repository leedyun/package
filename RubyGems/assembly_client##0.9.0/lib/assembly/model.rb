module Assembly
  class Model
    include Enumerable

    undef :id if method_defined?(:id)
    undef :name if method_defined?(:name)

    attr_reader :id
    attr_reader :client

    def initialize(id=nil, client=nil)
      @id = id
      @client = client
      @values = {}
      @dirty_values = Set.new
    end

    def merge(values, client=nil)
      added = Set.new(values.keys - @values.keys)
      add_accessors(added)
      values.each do |k, v|
        @values[k] = Util.build(v, client)
      end
      self
    end

    def self.construct_from(response, client=nil)
      new(response[:id], client).merge(response, client)
    end

    def update_from(response)
      @dirty_values.clear
      merge(response)
    end

    def dirty?
      @dirty_values.any?
    end

    def [](k)
      @values[k.to_sym]
    end

    def []=(k, v)
      send(:"#{k}=", v)
    end

    def keys
      @values.keys
    end

    def values
      @values.values
    end

    def to_json(*a)
      JSON.generate(@values)
    end

    def as_json(*a)
      @values.as_json(*a)
    end

    def to_hash
      @values.inject({}) do |acc, (key, value)|
        acc[key] = value.respond_to?(:to_hash) ? value.to_hash : value
        acc
      end
    end

    def each(&blk)
      @values.each(&blk)
    end

    def self.class_name
      self.name.split('::')[-1]
    end

    def dirty_params
      @dirty_values.reduce({}) do |hsh, k|
        hsh[k] = @values[k]
        hsh
      end
    end

    protected

    def metaclass
      class << self; self; end
    end

    def add_accessors(keys)
      keys.each do |k|
        next if k == :id
        next if self.class.instance_methods(false).include?(k)
        self.class.class_eval %[
          def #{k}
            @values[:#{k}]
          end

          def #{k}=(v)
            @values[:#{k}] = v
            @dirty_values.add(:#{k})
          end
        ]
      end
    end
  end
end