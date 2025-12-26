require '../test_helper'
require 'active_model_serializer_plus'

class InnerClass
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModelSerializerPlus::Assignment

    attr_accessor :x

    def attributes
        { 'x' => nil
        }
    end
end

class ModelClass
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModelSerializerPlus::Assignment

    attr_accessor :a
    attr_accessor :b

    def attributes
        { 'a' => nil,
          'b' => nil
        }
    end

    def attribute_types
        { 'b' => 'InnerClass'
        }
    end
end

class ObjectClass
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModelSerializerPlus::Assignment

    attr_accessor :x
    attr_accessor :y

    def attributes
        { 'x' => nil,
          'y' => nil
        }
    end
end

class ArrayClass
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModelSerializerPlus::Assignment

    attr_accessor :integer_field
    attr_accessor :array_field

    def attributes
        { 'integer_field' => nil,
          'array_field' => nil
        }
    end

    def attribute_types
        { 'array_field' => [ 'Array', 'ObjectClass' ]
        }
    end
end

class HashClass
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModelSerializerPlus::Assignment

    attr_accessor :integer_field
    attr_accessor :hash_field

    def attributes
        { 'integer_field' => nil,
          'hash_field' => nil
        }
    end

    def attribute_types
        { 'hash_field' => [ 'Hash', 'ObjectClass' ]
        }
    end
end

class ContainerClass
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModelSerializerPlus::Assignment

    attr_accessor :integer_field
    attr_accessor :container_field

    def attributes
        { 'integer_field' => nil,
          'container_field' => nil
        }
    end

    def attribute_types
        { 'container_field' => [ 'Container', 'ObjectClass' ]
        }
    end
end

class AssignmentTest < ActiveSupport::TestCase
    include ActiveModel::Lint::Tests

    def setup
        @model = ModelClass.new
        @model.a = 'xyzzy'
        @model.b = InnerClass.new
        @model.b.x = 15

        @array = ArrayClass.new
        @array.integer_field = 15
        @array.array_field = Array.new
        o = ObjectClass.new
        o.x = 21
        o.y = 22
        @array.array_field << o
        o = ObjectClass.new
        o.x = 31
        o.y = 32
        @array.array_field << o
        o = ObjectClass.new
        o.x = 41
        o.y = 42
        @array.array_field << o

        @hash = HashClass.new
        @hash.integer_field = 16
        @hash.hash_field = Hash.new
        o = ObjectClass.new
        o.x = 21
        o.y = 22
        @hash.hash_field['first'] = o
        o = ObjectClass.new
        o.x = 31
        o.y = 32
        @hash.hash_field['second'] = o
        o = ObjectClass.new
        o.x = 41
        o.y = 42
        @hash.hash_field['third'] = o


        @container = ContainerClass.new
        @container.integer_field = 17
        @container.container_field = Hash.new
        o = ObjectClass.new
        o.x = 21
        o.y = 22
        @container.container_field['first'] = o
        o = ObjectClass.new
        o.x = 31
        o.y = 32
        @container.container_field['second'] = o
        o = ObjectClass.new
        o.x = 41
        o.y = 42
        @container.container_field['third'] = o
    end

    test 'deserialize ModelClass' do
        json = @model.to_json
        assert_kind_of String, json, 'convert model to JSON'

        r = ModelClass.new
        r.from_json(json)
        assert_not_nil r, 'check new object'
        assert_kind_of ModelClass, r, 'check new object'
        assert_not_nil r.a, 'check attribute a'
        assert_kind_of String, r.a, 'check attribute a'
        assert_equal 'xyzzy', r.a, 'check attribute a'
        assert_not_nil r.b, 'check inner object'
        assert_kind_of InnerClass, r.b, 'check inner object'
        assert_not_nil r.b.x, 'check attribute x'
        assert_kind_of Integer, r.b.x, 'check attribute x'
        assert_equal 15, r.b.x, 'check attribute x'
    end

    test 'deserialize ArrayClass' do
        json = @array.to_json
        assert_kind_of String, json, 'convert model to JSON'

        r = ArrayClass.new
        r.from_json(json)
        assert_not_nil r, 'check new object'
        assert_kind_of ArrayClass, r, 'check new object'
        assert_not_nil r.integer_field, 'check integer field'
        assert_kind_of Integer, r.integer_field, 'check integer field'
        assert_equal 15, r.integer_field, 'check integer field'
        assert_not_nil r.array_field, 'check array field'
        assert_kind_of Array, r.array_field, 'check array field'
        assert_not_empty r.array_field, 'check array field length'
        assert_equal 3, r.array_field.length, 'check array field length'
        for i in 0..2 do
            assert_not_nil r.array_field[i], "check array element #{i}"
            assert_kind_of ObjectClass, r.array_field[i], "check array element #{i}"
            assert_not_nil r.array_field[i].x, "check array element #{i} x"
            assert_kind_of Integer, r.array_field[i].x, "check array element #{i} x"
            assert_equal (i+2)*10+1, r.array_field[i].x, "check array element #{i} x"
            assert_not_nil r.array_field[i].y, "check array element #{i} y"
            assert_kind_of Integer, r.array_field[i].y, "check array element #{i} y"
            assert_equal (i+2)*10+2, r.array_field[i].y, "check array element #{i} y"
        end
    end

    test 'deserialize HashClass' do
        json = @hash.to_json
        assert_kind_of String, json, 'convert model to JSON'

        r = HashClass.new
        r.from_json(json)
        assert_not_nil r, 'check new object'
        assert_kind_of HashClass, r, 'check new object'
        assert_not_nil r.integer_field, 'check integer field'
        assert_kind_of Integer, r.integer_field, 'check integer field'
        assert_equal 16, r.integer_field, 'check integer field'
        assert_not_nil r.hash_field, 'check hash field'
        assert_kind_of Hash, r.hash_field, 'check hash field'
        assert_not_empty r.hash_field, 'check hash field length'
        assert_equal 3, r.hash_field.length, 'check hash field length'
        i = 0
        ['first', 'second', 'third'].each do |idx|
            assert_not_nil r.hash_field[idx], "check hash element #{idx}"
            assert_kind_of ObjectClass, r.hash_field[idx], "check hash element #{idx}"
            assert_not_nil r.hash_field[idx].x, "check hash element #{idx} x"
            assert_kind_of Integer, r.hash_field[idx].x, "check hash element #{idx} x"
            assert_equal (i+2)*10+1, r.hash_field[idx].x, "check hash element #{idx} x"
            assert_not_nil r.hash_field[idx].y, "check hash element #{idx} y"
            assert_kind_of Integer, r.hash_field[idx].y, "check hash element #{idx} y"
            assert_equal (i+2)*10+2, r.hash_field[idx].y, "check hash element #{idx} y"
            i += 1
        end
    end

    test 'deserialize ContainerClass' do
        json = @container.to_json
        assert_kind_of String, json, 'convert model to JSON'

        r = ContainerClass.new
        r.from_json(json)
        assert_not_nil r, 'check new object'
        assert_kind_of ContainerClass, r, 'check new object'
        assert_not_nil r.integer_field, 'check integer field'
        assert_kind_of Integer, r.integer_field, 'check integer field'
        assert_equal 17, r.integer_field, 'check integer field'
        assert_not_nil r.container_field, 'check container field'
        assert_kind_of Hash, r.container_field, 'check container field'
        assert_not_empty r.container_field, 'check container field length'
        assert_equal 3, r.container_field.length, 'check container field length'
        i = 0
        ['first', 'second', 'third'].each do |idx|
            assert_not_nil r.container_field[idx], "check container element #{idx}"
            assert_kind_of ObjectClass, r.container_field[idx], "check container element #{idx}"
            assert_not_nil r.container_field[idx].x, "check container element #{idx} x"
            assert_kind_of Integer, r.container_field[idx].x, "check container element #{idx} x"
            assert_equal (i+2)*10+1, r.container_field[idx].x, "check container element #{idx} x"
            assert_not_nil r.container_field[idx].y, "check container element #{idx} y"
            assert_kind_of Integer, r.container_field[idx].y, "check container element #{idx} y"
            assert_equal (i+2)*10+2, r.container_field[idx].y, "check container element #{idx} y"
            i += 1
        end
    end
end
