module Exchanger
  # The Category element represents on category from the CategoryList
  #
  # https://msdn.microsoft.com/en-us/library/ee203806(v=exchg.80).aspx
  class Category < Element
    key :rename_on_first_use
    key :name
    key :color
    key :keyboard_shortcut
    key :last_time_used_notes
    key :last_time_used_journal
    key :last_time_used_contacts
    key :last_time_used_tasks
    key :last_time_used_calendar
    key :last_time_used_mail
    key :last_time_used
    key :guid

    def category_color
      @category_color ||= CategoryColor.new(color.to_i)
    end
  end
end
