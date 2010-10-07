module Exchanger
  # The Contact element represents a contact item in the Exchanger store.
  # http://msdn.microsoft.com/en-us/library/aa581315.aspx
  class Contact < Item
    # All the uri namespaces are singular (item, task, etc) except contacts.
    self.field_uri_namespace = :contacts

    element :file_as
    element :file_as_mapping
    element :display_name
    element :given_name
    element :initials
    element :middle_name
    element :nickname
    element :complete_name, :type => CompleteName, :readonly => true
    element :company_name
    element :email_addresses, :type => [EmailAddress]
    element :physical_addresses, :type => [PhysicalAddress]
    element :phone_numbers, :type => [PhoneNumber]
    element :assistant_name
    element :birthday, :type => Time
    element :business_home_page
    element :children, :type => [String]
    element :companies, :type => [String]
    element :contact_source # ActiveDirectory, Store
    element :department
    element :generation
    element :im_addresses, :type => [ImAddress]
    element :job_title
    element :manager
    element :mileage
    element :office_location
    element :postal_address_index
    element :profession
    element :spouse_name
    element :surname
    element :wedding_anniversary, :type => Time

    # Marked as private in Outlook?
    def private?
      sensitivity == "Private"
    end

    def self.search(name)
      response = Exchanger::ResolveNames.run(:name => name)
      response.contacts
    end
  end
end
