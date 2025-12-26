module Assembly
  class StaffMember < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List
  end

  Resource.build(StaffMember)
end