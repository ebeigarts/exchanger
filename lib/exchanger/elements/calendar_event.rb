module Exchanger
  # The CalendarEvent element represents a unique calendar item occurrence.
  # 
  # http://msdn.microsoft.com/en-us/library/aa564053(v=exchg.140)
  class CalendarEvent < Item
    element :start_time, :type => Time
    element :end_time, :type => Time
    element :busy_type
    element :calendar_event_details, :type => CalendarEventDetails
  end
end