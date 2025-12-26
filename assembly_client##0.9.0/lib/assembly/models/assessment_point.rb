module Assembly
  class AssessmentPoint < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List

    def results(params={})
      pages(path + "#{rank}/results", params)
    end
  end

  Resource.build(AssessmentPoint)
end