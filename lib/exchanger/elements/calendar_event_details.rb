module Exchanger
  # The CalendarEventDetails element provides additional information about a calendar event
  # 
  # http://msdn.microsoft.com/en-us/library/aa579732(v=exchg.140)
  class CalendarEventDetails < Item
    element :id, :type => Identifier
  end
end