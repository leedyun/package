require_relative "spec_helper.rb"

describe Ackintosh::Net::EmptyPort do
  context "#find without arguments" do
    it "should return Fixnum" do
      Ackintosh::Net::EmptyPort.find.should be_a(Fixnum)
    end
  end

  context "#find with 'udp'" do
    it "should return Fixnum" do
      Ackintosh::Net::EmptyPort.find("udp").should be_a(Fixnum)
    end
  end

  context "#used? with free port" do
    it "should return true" do
      port = Ackintosh::Net::EmptyPort.find
      Ackintosh::Net::EmptyPort.used?(port).should == false
    end
  end

  context "#used? with used port" do
    it "should return false" do
      port = Ackintosh::Net::EmptyPort.find
      socket = TCPServer.open("localhost", port)
      Ackintosh::Net::EmptyPort.used?(port).should == true
      socket.close
    end
  end
end
