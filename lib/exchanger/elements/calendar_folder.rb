module Exchanger
  class CalendarFolder < BaseFolder
    element :permission_set

    def new_calendar_item(attributes = {})
      contact = CalendarItem.new(attributes)
      contact.parent_folder_id = folder_id
      contact
    end
  end
end
