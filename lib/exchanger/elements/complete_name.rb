module Exchanger
  # The CompleteName element represents the complete name of a contact.
  # This element is read only and will not be sent on create/update.
  # 
  # http://msdn.microsoft.com/en-us/library/aa494294.aspx
  class CompleteName < Element
    element :title
    element :first_name
    element :middle_name
    element :last_name
    element :suffix
    element :initials
    element :full_name
    element :nickname
  end
end
