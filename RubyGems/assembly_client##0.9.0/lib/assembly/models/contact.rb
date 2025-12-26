module Assembly
  class Contact < ApiModel
    include Assembly::Actions::List
  end

  Resource.build(Contact)
end
