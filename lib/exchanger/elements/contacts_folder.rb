module Exchanger
  class ContactsFolder < BaseFolder
    element :permission_set

    def contacts
      items.select do |item|
        item.is_a?(Contact)
      end
    end

    def new_contact(attributes = {})
      contact = Contact.new(attributes)
      contact.parent_folder_id = folder_id
      contact
    end
  end
end
