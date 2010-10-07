module Exchanger
  # The Entry element represents a single e-mail address for a contact.
  # 
  # http://msdn.microsoft.com/en-us/library/aa564757.aspx
  class EmailAddress < Entry
    self.field_uri_namespace = :"contacts:EmailAddress"

    key :key # EmailAddress1, EmailAddress2 or EmailAddress3
    key :name
    key :routing_type
    key :mailbox_type

    # A text value that represents the entry is required if this element is used.
    element :text
  end
end
