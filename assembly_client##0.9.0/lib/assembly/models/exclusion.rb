module Assembly
  class Exclusion < ApiModel
    include Assembly::Actions::List
  end

  Resource.build(Exclusion)
end
