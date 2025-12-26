module Assembly
  class AcademicYear < ApiModel
    include Assembly::Actions::List
  end

  Resource.build(AcademicYear)
end