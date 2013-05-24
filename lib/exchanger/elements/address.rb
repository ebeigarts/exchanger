module Exchanger
  # The Address element represents a fully resolved e-mail address
  #
  # http://msdn.microsoft.com/en-us/library/dd899404(v=exchg.150).aspx
  class Address < Element
    element :name, :type => String
    element :email_address, :type => String
    element :routing_type, :type => String
    element :mailbox_type, :type => String
  end

end
