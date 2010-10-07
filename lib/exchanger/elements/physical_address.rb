module Exchanger
  # The Entry element describes a single physical address for a contact item.
  # http://msdn.microsoft.com/en-us/library/aa564323.aspx
  class PhysicalAddress < Entry
    self.field_uri_namespace = :"contacts:PhysicalAddress"

    key :key # Business, Home, Other

    element :street
    element :city
    element :state
    element :country_or_region
    element :postal_code
  end
end
