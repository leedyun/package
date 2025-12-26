Dir["#{File.dirname(__FILE__)}/requests/*.rb"].each { |path| require path }

module AppleNewsClient
  module Request
  end
end
