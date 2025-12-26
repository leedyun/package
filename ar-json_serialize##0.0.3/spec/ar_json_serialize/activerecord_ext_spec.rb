require 'spec_helper'
describe ::ArJsonSerialize::ActiveRecordExt do
  it 'should extend ActiveRecord::Base' do
    expect(::ActiveRecord::Base).to respond_to(:json_serialize)
  end

  it 'should call ActiveRecord::Base.serialize' do
    expect(::ActiveRecord::Base).to receive(:serialize).with('column', ::ArJsonSerialize::Serializer)
    ::ActiveRecord::Base.json_serialize('column')
  end
end