require File.dirname(__FILE__) + '/../spec_helper'


describe ApnsPolite::Message do

	it "new string" do
		m = ApnsPolite::Message.new('device_token', 'hello wowrld')
	end

	it "new hash" do
		m = ApnsPolite::Message.new('device_token', alert: 'message sample', badge: 3, sound: 'awesome.caf')
	end

	it "new hash with origin param" do
		m = ApnsPolite::Message.new('device_token', alert: 'message sample', badge: 3, sound: 'awesome.caf', other: { hoge: 0 })
	end

end

