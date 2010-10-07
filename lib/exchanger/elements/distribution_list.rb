module Exchanger
  # http://msdn.microsoft.com/en-us/library/aa566353.aspx
  class DistributionList < Item
    element :display_name
    element :file_as
    element :contact_source # ActiveDirectory, Store
  end
end
