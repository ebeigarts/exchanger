module Exchanger
  # The FileAttachment element represents a file that is attached to an item in the Exchange store.
  #
  # https://msdn.microsoft.com/en-us/library/office/aa580492(v=exchg.150).aspx
  class FileAttachment < Attachment
    element :is_contact_photo, type: Boolean
    element :content

    def content=(value)
      write_attribute(:content, Base64.encode64(value))
    end

    def content
      Base64.decode64(read_attribute(:content))
    end
  end
end
