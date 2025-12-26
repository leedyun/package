require 'minitest/autorun'
require File.dirname(__FILE__) + '/lib/model'

describe 'RecordTimestampSpec' do
  describe 'record timestamp' do
    before do
      @model = Model.create(:table_field => 'test')
    end

    it 'should has time in record_created_time when record created' do
      @model.record_created_time.wont_be_nil
      @model.record_updated_time.must_be_nil
    end

    it 'should has time in record_updated_time when record updated' do
      @model.record_updated_time.must_be_nil

      @model.table_field = 'updated'
      @model.save

      @model.record_updated_time.wont_be_nil
    end

    it 'should has different record_updated_time when record updated' do
      new_model = Model[@model.id]
      new_model.table_field = 'updated'
      new_model.save

      @model.record_updated_time.wont_equal new_model.record_updated_time
    end
  end
end
