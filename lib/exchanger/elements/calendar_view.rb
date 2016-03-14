module Exchanger
  # The CalendarView element defines a FindItem operation
  # as returning calendar items in a set as they appear in a calendar.
  # <CalendarView MaxEntriesReturned="" StartDate="" EndDate="" />

  # https://msdn.microsoft.com/en-us/library/aa564515.aspx
  class CalendarView < Element
    key :max_entries_returned
    key :start_date, type: Time
    key :end_date, type: Time
  end
end
