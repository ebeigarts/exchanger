module Exchanger
  # The Entry element represents an instant messaging (IM) address for a contact.
  #
  # http://msdn.microsoft.com/en-us/library/aa566142.aspx
  class ImAddress < Entry
    self.field_uri_namespace = :"contacts:ImAddress"

    element :title
    element :first_name
    element :middle_name
    element :last_name
    element :suffix
    element :initials
    element :full_name
    element :nickname

    # A text value that represents the entry is required if this element is used.
    element :text
  end
end
