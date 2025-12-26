require '../test_helper'
require 'active_model_type_validator'

class MyClass
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :string_field, object_type: { type: String }
    validates :integer_field, object_type: { type: Integer }
    validates :numeric_field, object_type: { type: [Integer, Float] }
    validates :boolean_field1, object_type: { type: %w[ TrueClass FalseClass ] }
    validates :boolean_field2, object_type: { type: [:TrueClass, :FalseClass] }

    attr_accessor :string_field
    attr_accessor :integer_field
    attr_accessor :numeric_field
    attr_accessor :boolean_field1
    attr_accessor :boolean_field2

    def initialize
        @string_field = 'my string'
        @integer_field = 42
        @numeric_field = 7
        @boolean_field1 = true
        @boolean_field2 = false
    end

end

class MyClass2
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :string_field, object_type: { type: String, allow_nil: true }

    attr_accessor :string_field

    def initialize
        @string_field = 'my string'
    end

end

class MyClass3
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :string_field, object_type: { type: String, allow_nil: false }

    attr_accessor :string_field

    def initialize
        @string_field = 'my string'
    end

end

class MyClass4
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :string_field, presence: true, object_type: { type: String }

    attr_accessor :string_field

    def initialize
        @string_field = 'my string'
    end

end

class ObjectTypeTest < ActiveSupport::TestCase

    def setup
        @model = MyClass.new
        @multiple = MyClass4.new
    end

    test "valid fields" do
        r = @model.valid?
        assert r
        assert_equal 0, @model.errors.size

        @model.numeric_field = 7.5
        r = @model.valid?
        assert r
        assert_equal 0, @model.errors.size

        @model.string_field = ''
        r = @model.valid?
        assert r
        assert_equal 0, @model.errors.size
    end

    test "invalid field one type" do
        @model.integer_field = 'xyzzy'
        r = @model.valid?
        assert_not r
        assert_equal 1, @model.errors.size
    end

    test "invalid field multiple types" do
        @model.numeric_field = 'a'
        r = @model.valid?
        assert_not r
        assert_equal 1, @model.errors.size
    end

    test "invalid multiple fields" do
        @model.integer_field = 'a'
        @model.string_field = 19
        r = @model.valid?
        assert_not r
        assert_equal 2, @model.errors.size
    end

    test "nil fields" do
        @model.integer_field = nil
        @model.string_field = nil
        r = @model.valid?
        assert r
        assert_equal 0, @model.errors.size
    end

    test "nil fields with allow nil true" do
        @model = MyClass2.new
        @model.string_field = nil
        r = @model.valid?
        assert r
        assert_equal 0, @model.errors.size
    end

    test "nil fields with allow nil false" do
        @model = MyClass3.new
        @model.string_field = nil
        r = @model.valid?
        assert_not r
        assert_equal 1, @model.errors.size
    end

    test "missing types list" do
        badflag = false
        flag = false
        begin
            class MyClass4
                include ActiveModel::Model
                include ActiveModel::Validations

                validates :string_field, object_type: {}

                attr_accessor :string_field

                def initialize
                    @string_field = 'my string'
                end
            end

            @model = MyClass4.new
        rescue ArgumentError
            flag = true
        rescue
            badflag = true
        end
        assert flag
        assert_not badflag
    end

    test "invalid types in list" do
        badflag = false
        flag = false
        begin
            class MyClass5
                include ActiveModel::Model
                include ActiveModel::Validations

                validates :string_field, object_type: { type: [:String, :InvalidType] }

                attr_accessor :string_field

                def initialize
                    @string_field = 'my string'
                end
            end

            @model = MyClass5.new
        rescue NameError
            badflag = true
        rescue ArgumentError
            flag = true
        rescue
            badflag = true
        end
        assert flag
        assert_not badflag
    end

    test 'multiple validators on one line' do
        @multiple.string_field = 'my string'
        assert @multiple.valid?, 'with valid object type'

        @multiple.string_field = 17
        assert_not @multiple.valid?, 'with invalid object type'
    end

end
