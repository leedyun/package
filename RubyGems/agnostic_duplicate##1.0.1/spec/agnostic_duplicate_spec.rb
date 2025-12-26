require 'spec_helper'

#:nodoc
module DuplicateSpec
  NO_DUP_VALUE = 1999
  DUP_VALUE = 'testValue'

  #:nodoc:
  class Base
    attr_accessor :id, :name, :images

    def initialize(options = {})
      @id = options[:id]
      @name = options[:name]
      @images = options[:images]
    end
  end

  #:nodoc
  # Dummy class duplicated through relationship. Not implementing Duplicable.
  class Image
    attr_accessor :id, :caption
    def initialize(options = {})
      @id = options[:id]
      @caption = options[:caption]
    end
  end

  #:nodoc
  # Dummy class duplicated through relationship. Implementing Duplicable.
  class ImageDuplicable < Image
    include Agnostic::Duplicate
    attr_duplicable :caption
  end

  # Factory for dummy image lists
  def self.create_list(class_name, size)
    const_name = class_name.to_s.split('_').map(&:capitalize).join
    klass = DuplicateSpec.const_get(const_name)
    [].tap do |list|
      size.times do |n|
        instance = klass.new(id: n, caption: "Cap #{n}")
        instance.stub(:dup).and_return(klass.new(id: n))
        list << instance
      end
    end
  end
end

RSpec.shared_context 'iterable field not dup' do
  before(:each) do
    @images = DuplicateSpec.create_list image_type, 3
    @dummy = DuplicateSpec::DeepCopy.new(id: 1, name: 'Dummy', images: @images)
    @dummy.stub(:dup).and_return(
      DuplicateSpec::DeepCopy.new(id: 1), name: 'Dummy'
    )
    @duplicate = @dummy.duplicate
  end
end

RSpec.shared_context 'not iterable field not dup' do
  before(:each) do
    @dummy = DuplicateSpec::DeepCopy.new(id: 1, name: attribute_value)
    @dummy.stub(:dup).and_return(DuplicateSpec::DeepCopy.new(id: 1))
    @duplicate = @dummy.duplicate
  end
end

describe Agnostic::Duplicate do

  subject { @dummy }

  describe '#duplicate' do
    it { respond_to :duplicate }
    it { respond_to :duplicable_config }
    it { respond_to :duplicate_as_new_instance? }
    it { respond_to :attr_duplicable }

    context 'when applying changesets' do
      context 'when deep copy strategy' do
        before(:all) do
          module DuplicateSpec
            #:nodoc
            class DeepCopy < Base
              include Agnostic::Duplicate
              attr_duplicable :name, :images
            end
          end
        end
        context 'when attribute is iterable' do
          context 'when elements implement Duplicable' do
            let(:image_type) { :image_duplicable }
            include_context 'iterable field not dup'

            it 'is duplicated the collection' do
              expect(@duplicate.images.size).to be(@images.size)
            end
            it 'copies duplicable attributes' do
              @duplicate.images.zip(@dummy.images).each do |copy, parent|
                expect(copy.caption).to eq(parent.caption)
              end
            end
          end
          context "when elements don't implement Duplicable" do
            let(:image_type) { :image }
            include_context 'iterable field not dup'

            it 'is duplicated the collection' do
              expect(@duplicate.images.size).to be(@images.size)
            end
            it "doesn't copy no duplicable attributes" do
              @duplicate.images.each do |image|
                expect(image.caption).to be(nil)
              end
            end
          end
        end
        context 'when attribute is not iterable' do
          context "when it cann't be dupped" do
            let(:attribute_value) { DuplicateSpec::NO_DUP_VALUE }
            include_context 'not iterable field not dup'

            it 'is duplicated' do
              expect(@duplicate.name).to eq(DuplicateSpec::NO_DUP_VALUE)
            end
          end
          context 'when it can be dupped' do
            let(:attribute_value) { DuplicateSpec::DUP_VALUE }
            include_context 'not iterable field not dup'

            it 'is duplicated' do
              expect(@duplicate.name).to eq(DuplicateSpec::DUP_VALUE)
            end
          end
        end
      end
      context 'when shallow copy strategy' do
        before :all do
          module DuplicateSpec
            #:nodoc
            class ShallowCopy < Base
              include Agnostic::Duplicate
              attr_duplicable :images, strategy: :shallow_copy
            end
          end
        end

        before(:each) do
          @images = DuplicateSpec.create_list :image_duplicable, 3
          @dummy = DuplicateSpec::ShallowCopy.new(
            id: 1,
            name: DuplicateSpec::DUP_VALUE,
            images: @images)
          @duplicate = @dummy.duplicate
        end

        it 'copies values keeping the object reference' do
          expect(@duplicate.images).to be(@images)
        end
      end
    end
    context 'when applying hook after duplicate' do
      before(:all) do
        module DuplicateSpec
          #:nodoc
          class DeepCopyWithHook < Base
            include Agnostic::Duplicate
            attr_duplicable :name, :images

            def hook_after_duplicate!(duplicate)
              duplicate.name = "#{duplicate.name} hooked"
            end
          end
        end
      end
      before(:each) do
        @name = DuplicateSpec::DUP_VALUE
        @dummy = DuplicateSpec::DeepCopyWithHook.new(id: 1, name: @name)
        @dummy.stub(:dup).and_return(
          DuplicateSpec::DeepCopyWithHook.new(id: 1))
        @duplicate = @dummy.duplicate
      end
      it 'overrides changes made during duplication' do
        expect(@duplicate.name).to eq("#{@name} hooked")
      end
    end
    context 'when duplicating with new instance option' do
      before :all do
        module DuplicateSpec
          #:nodoc
          class NewInstanceTest < Base
            include Agnostic::Duplicate
            duplicable_config new_instance: true
            attr_duplicable :images
          end
        end
      end

      before(:each) do
        @images = DuplicateSpec.create_list :image_duplicable, 3
        @dummy = DuplicateSpec::NewInstanceTest.new(
          id: 1,
          name: DuplicateSpec::DUP_VALUE,
          images: @images)
        @duplicate = @dummy.duplicate
      end

      it 'duplicates only fields for #attr_duplicable' do
        expect(@duplicate.id).to be(nil)
        expect(@duplicate.name).to be(nil)
        expect(@duplicate.images.size).to be(@images.size)
      end
    end
    context 'when invalid settings' do
      context "when attribute doesn't exist" do
        it 'raises an attribute not found error' do
          expect do
            #:nodoc
            module DuplicateSpec
              #:nodoc
              class InvalidAttributeTest
                include Agnostic::Duplicate
                attr_duplicable :name
              end
              InvalidAttributeTest.new.duplicate
            end
          end.to raise_error Agnostic::Duplicate::ChangeSet::AttributeNotFound
        end
      end
      context 'when custom dup_template lacks of duplicable attribute' do
        it 'raises a copy error on deep copy' do
          expect do
            #:nodoc
            module DuplicateSpec
              #:nodoc
              class InvalidDupTemplateTest < Base
                include Agnostic::Duplicate
                attr_duplicable :name
              end

              obj = Object.new
              obj.define_singleton_method('name=') do
                fail 'Internal error'
              end

              InvalidDupTemplateTest.new.duplicate dup_template: obj
            end
          end.to raise_error Agnostic::Duplicate::ChangeSet::CopyError
        end
        it 'raises a copy error on shallow copy' do
          expect do
            #:nodoc
            module DuplicateSpec
              #:nodoc
              class InvalidDupTemplateTest < Base
                include Agnostic::Duplicate
                attr_duplicable :name, strategy: :shallow_copy
              end

              obj = Object.new
              obj.define_singleton_method('name=') do
                fail 'Internal error'
              end

              InvalidDupTemplateTest.new.duplicate dup_template: obj
            end
          end.to raise_error Agnostic::Duplicate::ChangeSet::CopyError
        end
      end
      context 'when duplicable config is invalid' do
        it 'raises an exception' do
          expect do
            #:nodoc
            module DuplicateSpec
              #:nodoc
              class DummyInvalidConfig
                include Agnostic::Duplicate
                duplicable_config :new_instance
                attr_duplicable :name
              end

              DummyInvalidConfig.new.duplicate
            end
          end.to raise_error('Invalid options configuration')
        end
      end
    end
  end
end
