require 'minitest/autorun'
require File.dirname(__FILE__) + '/lib/model'

describe 'RecordVersionSpec' do
  describe 'record version' do
    before do
      @model = Model.create(:table_field => 'test')
    end

    it 'should has md5 format version in record_version when record created' do
      @model.record_version.wont_be_nil
      @model.record_version.size.must_equal 32
    end

    it 'should has md5 format version in record_version when record created' do
      @model.record_version.wont_be_nil
      @model.record_version.size.must_equal 32
    end

    it 'should has md5 format version in record_version when record created' do
      new_model = Model[@model.id]
      new_model.table_field = 'updated'
      new_model.save

      @model.record_version.wont_equal new_model.record_version
    end

    it 'should not update version when record was not modified' do
      new_model = Model[@model.id]
      new_model.save

      @model.record_version.must_equal new_model.record_version
    end

    it 'should has different version when record was updated' do
      new_model = Model[@model.id]
      new_model.table_field = 'updated'
      new_model.save

      @model.record_version.wont_equal new_model.record_version
    end
  end
end
