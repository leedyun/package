module Assembly
  class GradeSet < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::Create
    include Assembly::Actions::List
  end

  Resource.build(GradeSet)
end