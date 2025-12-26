require File.dirname(__FILE__) + '/../spec_helper'

describe ApnsPolite::Notification do

	module N
		PEM = '/home/homepage/html/apns.pem'
		HOST = 'gateway.push.apple.com'
		PORT = 2195
		PASSWORD = nil
		DEVICE_TOKEN = '...'
	end

	it "new arg 0" do
		ApnsPolite::Notification.new
	end

	it "new" do
		ApnsPolite::Notification.new host: N::HOST, port: N::PORT, pem: N::PEM, password: N::PASSWORD
	end

	it "connect" do
		a = ApnsPolite::Notification.new
		a.connection N::HOST, N::PORT, N::PEM, N::PASSWORD
	end

	it "reconnect" do
		a = ApnsPolite::Notification.new host: N::HOST, port: N::PORT, pem: N::PEM, password: N::PASSWORD
		a.reconnection
	end

	it 'push' do
		m = ApnsPolite::Message.new(N::DEVICE_TOKEN, 'aiueo')
		a = ApnsPolite::Notification.new host: N::HOST, port: N::PORT, pem: N::PEM, password: N::PASSWORD
		a.push m
	end
end
