require 'spec_helper'
require 'ostruct'

describe Android::Publisher::Edit do
  let(:client)     { double(Android::Publisher::Connection)}

  #TODO: This is a clear indication that the design sucks
  let(:client1)     { double("Android::Publisher::Connection1")}

  let(:edit) { described_class.new(client, nil) }

  before do
    client.stub(:add_endpoint).with(any_args).and_return(client1)
  end
  context 'insert' do
    before do
      client1.should_receive(:post).and_return(OpenStruct.new( :status => 200, :body=> {:id=>1}.to_json ))
      client.should_receive(:add_endpoint).with('edits')
    end

    it 'should add edit id to the client path ' do
      client1.should_receive(:add_endpoint).with(1)
      edit.insert
    end

    it 'should return the response' do
      client1.should_receive(:add_endpoint).with(1)
      edit.insert.should be_eql({'id' => 1})
    end
  end
end
