module Exchanger
  # Entry (EmailAddress), 
  # Entry (IMAddress), 
  # Entry (PhoneNumber), 
  # Entry (PhysicalAddress)
  class Entry < Element
    def tag_name
      "Entry"
    end
  end
end
