module Assembly
  class ApiModel < Model
    def path
      "#{self.class.path}/#{id}"
    end

    def self.path
      "/#{Util.underscore(self.class_name)}s"
    end

    protected

    def pages(path, params)
      results = []
      page = 1
      while page
        response = client.get(path, {page: page, per_page: 100}.merge(params))
        ret = Util.build(response, client)
        results += ret.data
        page = ret.next_page
      end
      results
    end
  end
end