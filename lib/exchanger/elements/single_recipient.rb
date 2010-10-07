module Exchanger
  # Organizer, Sender, From, etc
  class SingleRecipient < Element
    element :mailbox, :type => Mailbox
  end
end
