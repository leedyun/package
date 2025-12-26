require 'rubygems'
require 'chef'
require 'chef/handler'
require 'datadog/statsd'

class ChefHandlerStatsd < Chef::Handler
  def initialize(host = 'localhost', port = 8125, tags = {})
    @statsd = Datadog::Statsd.new(host, port)
    @tags = tags
  end

  def report
    tags = {
      nodeName: node.name
    }

    tags.merge!(@tags)

    @statsd.count('chef-client.total_runs', 1, tags: tags)
    @statsd.timing('chef-client.run_time', (run_status.elapsed_time * 1000), tags: tags)
    @statsd.count('chef-client.total_resources', run_status.all_resources.length, tags: tags)
    @statsd.count('chef-client.updated_resources', run_status.updated_resources.length, tags: tags)

    if run_status.failed?
      @statsd.count('chef-client.failed_runs', 1, tags: tags)
    else
      @statsd.count('chef-client.success_runs', 1, tags: tags)
    end
  end
end
  
