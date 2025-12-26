class OctopusApi
  include API

  RESOURCE_TYPES = ['Environments','Projects','ProjectGroups','NugetFeeds','LibraryVariableSets','Machines','Lifecycles','Users','Releases','Deployments']


  def initialize
    create_api(ConfigStore.octopus)
  end

  def create_resource(type, query)
    check_type type
    request(:post, "/#{type}", query)
  end

  def remove_resource(type, id)
    check_type type
    request(:delete, "/#{type}/#{id}")
  end

  def get_resource(type)
    check_type type
    return request(:get, "/#{type}/all")
  end

  def resource_exists?(type, name)
    resource = get_resource_by_type_and_name(type, name)
    return (resource && resource != [])
  end

  def get_resource_by_type_and_name(type, name = nil)
    resources = get_resource(type)
    if name && name != ''
      filter = [*name].join("|")

      filtered_resources = resources.select do |resource|
        resource['Name'] =~ /#{filter}/
      end

      if filtered_resources.any?
        Log.info "#{filtered_resources.count} resources found with filter #{filter}"
        filtered_resources
      else
        Log.info "No #{type} found with filter #{filter}"
        return nil
      end
    else
      resources
    end
  end

  def check_type(type)
    raise NameError, "Invalid resource type supplied: '#{type}'" unless RESOURCE_TYPES.include? type
  end
end

