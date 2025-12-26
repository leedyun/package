module ABBYY::Cloud::Types
  include Dry::Types.module

  # Gem-specific primitive types
  FilledArray = Array.constrained(min_size: 1)

  # Registers new coercible type
  def self.register_type(klass, as: nil, constructor: :new)
    type_name  = Inflecto.underscore(as || klass.name.split("::").last)
    definition = Dry::Types::Definition.new(klass).constructor do |value|
      case value
      when nil   then raise
      when klass then value
      else klass.send(constructor, value)
      end
    end

    Dry::Types.register type_name, definition
    Dry::Types.define_constants self, [type_name]
  end

  register_type ::Time, as: "coercible.time", constructor: :parse
end
