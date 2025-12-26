module Assembly
  class Facet < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List
  end

  Resource.build(Facet)
end