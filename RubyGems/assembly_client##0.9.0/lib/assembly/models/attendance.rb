module Assembly
  class Attendance < ApiModel
    include Assembly::Actions::List
  end

  Resource.build(Attendance)
end