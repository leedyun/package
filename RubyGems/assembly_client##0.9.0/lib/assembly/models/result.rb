module Assembly
  class Result < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List
    include Assembly::Actions::Create
    include Assembly::Actions::Delete
    include Assembly::Actions::Update
  end

  Resource.build(Result)
end