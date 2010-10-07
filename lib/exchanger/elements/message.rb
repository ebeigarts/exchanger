module Exchanger
  # The Message element represents a Microsoft Exchanger e-mail message.
  #
  # http://msdn.microsoft.com/en-us/library/aa494306.aspx
  class Message < Item
    self.field_uri_namespace = :message
    element :sender, :type => SingleRecipient
    element :to_recipients, :type => [Mailbox]
    element :cc_recipients, :type => [Mailbox]
    element :bcc_recipients, :type => [Mailbox]
    element :is_read_receipt_requested, :type => Boolean
    element :is_delivery_receipt_requested, :type => Boolean
    element :conversation_index # base64Binary
    element :conversation_topic
    element :from, :type => SingleRecipient
    element :internet_message_id
    element :is_read, :type => Boolean
    element :is_response_requested, :type => Boolean
    element :references
    element :reply_to, :type => [Mailbox]
    element :received_by, :type => SingleRecipient
    element :received_representing, :type => SingleRecipient
  end
end
