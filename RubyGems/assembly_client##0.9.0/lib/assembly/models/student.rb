module Assembly
  class Student < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List
  end

  Resource.build(Student)
end
