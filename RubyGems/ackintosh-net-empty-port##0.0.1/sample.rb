$:.unshift(File.expand_path('../lib', __FILE__))
require "ackintosh/net/empty_port"

p Ackintosh::Net::EmptyPort.used?(49152)
p Ackintosh::Net::EmptyPort.find
