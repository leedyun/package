class TeamcityApi
  include API

  def initialize
    create_api( ConfigStore.teamcity )
  end

  def build_queue
    request(:get, 'buildQueue')
  end

  def create_build(build_config_id, properties={})
    properties_string = ""
    properties.each_pair do |k,v|
      properties_string << "<property name='#{k}' value='#{v}'/>\n"
    end
    data = "
      <build>
        <buildType id='#{build_config_id}'/>
      <properties>
        #{properties_string}
      </properties>
      </build>
    "
    request(:post, 'buildQueue', data, "xml")
  end

  def set_project_parameter(project_id,parameter,value)
    request(:put, "projects/#{project_id}/parameters/#{parameter}", value, "text")
  end

  def projects(parent_id=nil)
    list = Nokogiri::XML.parse(request(:get, 'projects').body)
    if parent_id
      (list.xpath '//project').select {|e| e.attributes['parentProjectId'].to_s ==  parent_id}
    else
      list
    end
  end
end
