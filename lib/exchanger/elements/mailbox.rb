module Exchanger
  # TODO It looks like this is the same as Address.
  #
  # The Mailbox element identifies a mail-enabled Active Directory object.
  #
  # The EmailAddress and ItemId elements identify a mailbox or distribution list.
  # The EmailAddress element identifies a mailbox or distribution list by SMTP address.
  # The ItemId element identifies a mailbox by an item identifier, which is associated with a particular mailbox.
  # The ItemId element cannot be used for sending a message to a distribution list or a contact in a public contacts folder.
  # An error will be thrown if this is used in a CreateItem, UpdateItem, or SendItem operation
  # when an attempt is made to send a message to a distribution list or contact in a contacts public folder.
  # Use the ExpandDL operation to get the SMTP address and then send the message by
  # using the EmailAddress element instead of the ItemId element.
  #
  # http://msdn.microsoft.com/en-us/library/aa565036.aspx
  class Mailbox < Element
    element :name
    element :email_address
    element :routing_type
    element :mailbox_type # Mailbox, PublicDL, PrivateDL, Contact, PublicFolder
    element :item_id, :type => Identifier

    def self.search(name)
      response = Exchanger::ResolveNames.run(:name => name)
      response.mailboxes
    end

    def members
      return [] unless mailbox_type == "PublicDL"
      response = Exchanger::ExpandDL.run(:mailbox => self)
      response.mailboxes
    end
  end
end
