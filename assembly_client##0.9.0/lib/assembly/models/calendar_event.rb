module Assembly
  class CalendarEvent < ApiModel
    include Assembly::Actions::List
  end

  Resource.build(CalendarEvent)
end
