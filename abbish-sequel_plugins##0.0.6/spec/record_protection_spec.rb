require 'minitest/autorun'
require File.dirname(__FILE__) + '/lib/model'

describe 'RecordProtectionSpec' do
  describe 'record protection' do
    before do
      @model = Model.create(:table_field => 'test')
    end

    it 'should has method to set record protection' do
      defined?(@model.record_protected?).wont_be_nil
      defined?(@model.set_record_protected).wont_be_nil
      defined?(@model.set_record_protected!).wont_be_nil

      @model.record_protected?.must_equal false

      @model.set_record_protected

      @model.record_protected?.must_equal true

      model = Model[@model.id]
      model.record_protected?.must_equal false

      @model.set_record_protected!

      model = Model[@model.id]
      model.record_protected?.must_equal true
    end

    it 'should has error when destroy a protected record' do
      @model.set_record_protected!

      model = Model[@model.id]
      proc { model.destroy }.must_raise Abbish::Sequel::Plugins::Model::SuperRecord::Protection::ProtectedError
    end
  end
end
