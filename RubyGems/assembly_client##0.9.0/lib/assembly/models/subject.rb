module Assembly
  class Subject < ApiModel
    include Assembly::Actions::List
  end

  Resource.build(Subject)
end
