require 'endpoint_flux'
require 'rails'

module EndpointFlux
  class Railtie < Rails::Railtie
    railtie_name :endpoint_flux

    rake_tasks do
       path = File.expand_path(__dir__)
       Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end

