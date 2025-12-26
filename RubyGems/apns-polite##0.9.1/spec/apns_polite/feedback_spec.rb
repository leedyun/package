require File.dirname(__FILE__) + '/../spec_helper'

describe ApnsPolite::Feedback do
	module F
	        PEM = '/home/homepage/html/apns.pem'
	        HOST = 'feedback.push.apple.com'
	        PORT = 2196
		PASSWORD = nil
	end

        it "new arg 0" do
                ApnsPolite::Feedback.new
        end

        it "new" do
                ApnsPolite::Feedback.new host: F::HOST, port: F::PORT, pem: F::PEM, password: F::PASSWORD
        end

        it "connect" do
                a = ApnsPolite::Feedback.new
                a.connection F::HOST, F::PORT, F::PEM, F::PASSWORD
        end

        it "reconnect" do
                a = ApnsPolite::Feedback.new host: F::HOST, port: F::PORT, pem: F::PEM, password: F::PASSWORD
                a.reconnection
        end

        it 'stream' do
                a = ApnsPolite::Feedback.new host: F::HOST, port: F::PORT, pem: F::PEM, password: F::PASSWORD
                a.stream do |token, time|
			p token
			p time
		end
        end
end

