require '../test_helper'
require 'active_model_type_validator'

class MyClass1
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :a1, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :b1, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :c1, presence: true, contents: true

    attr_accessor :a1
    attr_accessor :b1
    attr_accessor :c1

end

class MyClass1a
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :a1, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :b1, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :c1, presence: true

    attr_accessor :a1
    attr_accessor :b1
    attr_accessor :c1

end

class MyClass1b
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :a1, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :b1, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :c1, contents: { allow_nil: true }
    validates :c2, contents: true

    attr_accessor :a1
    attr_accessor :b1
    attr_accessor :c1
    attr_accessor :c2

end

class MyClass2
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :a2, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :b2, presence: true, numericality: { only_integer: true, greater_than: 0 }

    attr_accessor :a2
    attr_accessor :b2

end

class RecursiveTest < ActiveSupport::TestCase

    def setup
        @model = MyClass1.new
        @model.a1 = 57
        @model.b1 = nil
        @model.c1 = MyClass2.new
        @model.c1.a2 = 99
        @model.c1.b2 = nil

        @not_validated = MyClass1a.new
        @not_validated.a1 = 57
        @not_validated.b1 = nil
        @not_validated.c1 = MyClass2.new
        @not_validated.c1.a2 = 99
        @not_validated.c1.b2 = nil

        @no_child = MyClass1b.new
        @no_child.a1 = 57
        @no_child.b1 = nil
        @no_child.c1 = MyClass2.new
        @no_child.c1.a2 = 99
        @no_child.c1.b2 = nil
        @no_child.c2 = MyClass2.new
        @no_child.c2.a2 = 99
        @no_child.c2.b2 = nil

    end

    test 'valid parent valid child' do
        @model.b1 = 17
        @model.c1.b2 = 23
        assert @model.valid?
    end

    test 'valid parent invalid child' do
        @model.b1 = 17
        @model.c1.b2 = -23
        assert_not @model.valid?
    end

    test 'invalid parent valid child' do
        @model.b1 = -17
        @model.c1.b2 = 23
        assert_not @model.valid?
    end

    test 'invalid parent invalid child' do
        @model.b1 = -17
        @model.c1.b2 = -23
        assert_not @model.valid?
    end

    test 'valid parent invalid child not validated' do
        @not_validated.b1 = 17
        @not_validated.c1.b2 = -23
        assert @not_validated.valid?
    end

    test 'valid parent without child allow nil' do
        @no_child.b1 = 17
        @no_child.c1 = nil
        @no_child.c2.b2 = 23
        assert @no_child.valid?
    end

    test 'valid parent without child no allow nil' do
        @no_child.b1 = 17
        @no_child.c1.b2 = 23
        @no_child.c2 = nil
        assert_not @model.valid?
    end

end
