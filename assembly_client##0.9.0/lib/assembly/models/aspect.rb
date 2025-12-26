module Assembly
  class Aspect < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List
    include Assembly::Actions::Create
    include Assembly::Actions::Delete
  end

  Resource.build(Aspect)
end