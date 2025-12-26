module Assembly
  class YearGroup < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List

    def students(params={})
      response = client.get(path + '/students', params)
      Util.build(response, client)
    end
  end

  Resource.build(YearGroup)
end